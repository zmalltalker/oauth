require File.join(File.dirname(__FILE__), "spec_helper")

describe OAuth::RequestToken do
  describe "#authorize_url" do
    before :each do
      @consumer = stub(:authorize_url => "http://example.org/authorize")
      @instance = OAuth::RequestToken.new(@consumer, "token", "secret")
    end

    it "should use the consumer's authorize_url" do
      @consumer.expects(:authorize_url).returns(url = "http://example.com/authorize")
      @instance.authorize_url.should match(/#{url}/)
    end

    it "should include the token in the querystring" do
      uri = URI.parse(@instance.authorize_url)
      uri.query.should match(/oauth_token=#{@instance.token}/)
    end

    it "should include additional OAuth parameters in the querystring" do
      uri = URI.parse(@instance.authorize_url(:oauth_callback => cb = "http://example.org/"))
      uri.query.should match(/oauth_callback=#{CGI.escape(cb)}/)
    end

    it "should include additional (arbitrary) parameters in the querystring" do
      uri = URI.parse(@instance.authorize_url(:foo => "bar"))
      uri.query.should match(/foo=bar/)
    end

    it "should include multi-valued parameters in the querystring" do
      uri = URI.parse(@instance.authorize_url(:foo => ["bar", "baz"]))
      uri.query.should match(/foo=bar/)
      uri.query.should match(/foo=baz/)
    end
  end
end
