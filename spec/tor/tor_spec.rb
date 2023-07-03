# frozen_string_literal: true

require "spec_helper"
require "net/http"
require "socksify/http"

describe Tor do
  context "when different values" do
    before do
      described_class.configure do |config|
        config.ip = "a"
        config.port = 9051
        config.add_header("User-Agent", "Netscape 2.0")
      end

      stub_request(:get, "http://google.com/").with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Netscape 2.0"
        }
      ).to_return(status: 200, body: "", headers: {})
    end

    it "calls correctly" do
      allow(Net::HTTP).to receive(:SOCKSProxy).with("a", 9051).and_call_original

      res = Tor::HTTP.get(URI("http://google.com/"))

      expect(res.code).to eq("200")
    end
  end
end
