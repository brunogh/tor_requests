require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "Http" do
  
  describe "get" do
    
    context "with invalid parameters" do
      it "does not work" do
        expect { Tor::HTTP.get("google.com") }.to raise_error
      end
    end
    
    context "with URI parameter" do
      it "works" do
        res = Tor::HTTP.get(URI('http://google.com/'))
        res.code.should eq("301")
      end
    end
    
    context "with host, path and port parameters" do
      it "works" do
        res = Tor::HTTP.get("google.com", "/", 80)
        res.code.should eq("301")
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
      it "works" do
        res = Tor::HTTP.post(URI('http://posttestserver.com/post.php?dir=example'), {"q" => "query", "var" => "variable"})
        res.code.should eq("200")
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
