require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "Configure" do

  it "default port" do
    Tor::Configuration.new.port.should eq(9050)
  end

  it "default headers" do
    Tor::Configuration.new.headers.should eq(Hash.new)  
  end
  

  it "default ip" do
    Tor::Configuration.new.ip.should eq('127.0.0.1')
  end

  context "initialize" do

    it "default headers" do
      config = Tor::Configuration.new
      config.add_header('User-Agent', 'Netscape 2.0')
      config.headers.should eq({'User-Agent' => 'Netscape 2.0'})
    end
    

    it "default port" do
      config = Tor::Configuration.new
      config.port = 99
      config.port.should eq(99)
    end

    it "default ip" do
      config = Tor::Configuration.new
      config.ip = "whatever"
      config.ip.should eq("whatever")
    end
  end

end
