require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TorRequests" do
  it "makes a HTTP request to Google" do
    res = Request.new.http("google.com", 80, "/")
    res.code.should eq("301")
  end
end
