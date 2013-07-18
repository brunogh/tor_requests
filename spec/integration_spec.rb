require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'net/http'
require 'socksify/http'

describe "Configure" do

  context "different values" do
    it "calls correctly" do

      Tor.configure do |config|
        config.ip = "a"
        config.port = 9051
        config.add_header('User-Agent', 'Netscape 2.0')
      end

      proxy = Net::HTTP.SOCKSProxy("127.0.0.1", 9050)
      proxy.stub(:start)
      Net::HTTP.should_receive(:SOCKSProxy).with("a", 9051).and_return( proxy)
      Tor::HTTP.get(URI('http://google.com/'))
    end
  end

end
