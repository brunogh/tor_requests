require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "Http" do
  
  describe "get" do
    it "default params" do
      res = Tor::HTTP.get("google.com")
      res.code.should eq("301")
    end

    it "makes a HTTP request to Google" do
      res = Tor::HTTP.get("google.com", "/", 80)
      res.code.should eq("301")
    end
    
  end

end
