require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Http" do

  describe "get" do

    context "with invalid parameters" do
      it "does not work" do
        expect { Tor::HTTP.get("google.com") }.to raise_error
      end
    end

    context "with URI parameter" do
      ["http", "https"].each do |protocol|
        it "follows the #{protocol} redirects" do
          res = Tor::HTTP.get(URI("#{protocol}://google.com/"))
          res.code.should eq("200")
        end

        context "with custom redirects limit" do
          it "raises TooManyRedirects error after 1 retry" do
            expect { Tor::HTTP.get(URI("#{protocol}://bit.ly/1ngrqeH"), nil, nil, 1) }.to raise_error("Tor::HTTP::TooManyRedirects")
          end
        end

      end
    end

    context "with host, path and port parameters" do
      it "works" do
        res = Tor::HTTP.get("google.com", "/", 80)
        res.code.should eq("200")
      end
    end

  end

  describe "post" do

    context "with invalid parameters" do
      it "does not work" do
        expect { Tor::HTTP.post("google.com") }.to raise_error
      end
    end

    context "with URI parameter" do
      ["http", "https"].each do |protocol|
        it "works with #{protocol}" do
          res = Tor::HTTP.post(URI("#{protocol}://posttestserver.com/post.php?dir=example"), {"q" => "query", "var" => "variable"})
          res.code.should eq("200")
        end
      end
    end

    context "with host, path and port parameters" do
      it "works" do
        res = Tor::HTTP.post('posttestserver.com', {"q" => "query", "var" => "variable"}, '/post.php?dir=example', 80)
        res.code.should eq("200")
      end

    end

  end

end
