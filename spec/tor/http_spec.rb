# frozen_string_literal: true

require "spec_helper"

describe Tor::HTTP do
  subject(:tor_http) { described_class }

  describe "get" do
    context "with invalid parameters" do
      it "does not work" do
        expect { tor_http.get("google.com") }.to raise_error(NoMethodError, /undefined method `host'/)
      end
    end

    context "with URI parameter" do
      %w[http https].each do |protocol|
        it "follows the #{protocol} redirects" do
          stub_request(:get, "#{protocol}://google.com/").with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Ruby"
            }
          ).to_return(status: 200, body: "", headers: {})

          res = tor_http.get(URI("#{protocol}://google.com/"))

          expect(res.code).to eq("200")
        end
      end
    end

    context "with custom redirects limit" do
      %w[http https].each do |protocol|
        before do
          stub_request(:get, "#{protocol}://google.com/1234").with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Ruby"
            }
          ).to_return(status: 302, body: "",
                      headers: { "Location" => "#{protocol}://google.com/12345" })

          stub_request(:get, "#{protocol}://google.com/12345").with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Ruby"
            }
          ).to_return(status: 302, body: "", headers: { "Location" => "#{protocol}://google.com/123456" })
        end

        it "raises TooManyRedirects error after 1 retry" do
          expect do
            tor_http.get(URI("#{protocol}://google.com/1234"), nil, nil, 1)
          end.to raise_error(Tor::HTTP::TooManyRedirects)
        end
      end
    end

    context "with host, path and port parameters" do
      before do
        stub_request(:get, "http://google.com/").with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby"
          }
        ).to_return(status: 200, body: "", headers: {})
      end

      it "returns 200" do
        res = tor_http.get("google.com", "/", 80)

        expect(res.code).to eq("200")
      end
    end
  end

  describe "post" do
    context "with invalid parameters" do
      it "does not work" do
        expect { tor_http.post("google.com") }.to raise_error(NoMethodError, /undefined method `host'/)
      end
    end

    context "with URI parameter" do
      %w[http https].each do |protocol|
        before do
          stub_request(:post, "#{protocol}://posttestserver.com/post.php?dir=example").with(
            body: { "q" => "query", "var" => "variable" },
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/x-www-form-urlencoded",
              "User-Agent" => "Ruby"
            }
          ).to_return(status: 200, body: "", headers: {})
        end

        it "returns 200 with #{protocol}" do
          res = tor_http.post(URI("#{protocol}://posttestserver.com/post.php?dir=example"),
                              { "q" => "query", "var" => "variable" })

          expect(res.code).to eq("200")
        end
      end
    end

    context "with host, path and port parameters" do
      before do
        stub_request(:post, "http://example.org/post.php?dir=example").with(
          body: { "q" => "query", "var" => "variable" },
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/x-www-form-urlencoded",
            "User-Agent" => "Ruby"
          }
        ).to_return(status: 200, body: "", headers: {})
      end

      it "returns 200" do
        res = tor_http.post("example.org", { "q" => "query", "var" => "variable" }, "/post.php?dir=example", 80)

        expect(res.code).to eq("200")
      end
    end
  end
end
