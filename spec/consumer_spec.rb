require File.join(File.dirname(__FILE__), "spec_helper")
require "shared_consumer_examples"

describe OAuth::Consumer do
  describe "initialization" do
    describe "with defaults" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret"

        @authorize_path     = OAuth::Consumer::DEFAULT_AUTHORIZE_PATH
        @access_token_path  = OAuth::Consumer::DEFAULT_ACCESS_TOKEN_PATH
        @request_token_path = OAuth::Consumer::DEFAULT_REQUEST_TOKEN_PATH
      end

      it "#key should contain the consumer key" do
        @instance.key.should == @consumer_key
      end

      it "#secret should contain the consumer secret" do
        @instance.secret.should == @consumer_secret
      end

      it "site should be empty" do
        # TODO one could argue that the lack of a site and specified *_urls
        # constitutes a fatal error (can't generate urls properly)
        @instance.site.should be_empty
      end

      it_should_behave_like "an OAuth::Consumer with known paths"
      it_should_behave_like "an OAuth::Consumer without a :site parameter"

      it "scheme should be header auth" do
        @instance.scheme.should == :header
      end

      it "HTTP method should be POST" do
        @instance.http_method.should == :post
      end
    end

    describe "with a :site parameter" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret",
          :site   => @site = "http://example.com"
      end

      it_should_behave_like "an OAuth::Consumer with a :site parameter"
    end

    describe "with an invalid :site parameter" do
      it "should use the parsed 'path' as the host"
    end

    describe "with a :site parameter specified as a URI" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret",
          :site   => site_uri = URI.parse("http://example.com")

        @site = site_uri.to_s
      end

      it_should_behave_like "an OAuth::Consumer with a :site parameter"
    end

    describe "with custom OAuth paths and no base URL" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret",
          :authorize_path     => @authorize_path     = "/authorize",
          :access_token_path  => @access_token_path  = "/access_token",
          :request_token_path => @request_token_path = "/request_token"
      end

      it_should_behave_like "an OAuth::Consumer with known paths"
      it_should_behave_like "an OAuth::Consumer without a :site parameter"
    end

    describe "with custom OAuth URLs" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret",
          :authorize_url     => @authorize_url     = "http://example.com/authorize",
          :access_token_url  => @access_token_url  = "http://example.com/access_token",
          :request_token_url => @request_token_url = "http://example.com/request_token"

        # URLs are too specific for paths to be sufficient
        @specific = true
      end

      it_should_behave_like "an OAuth::Consumer with known URLs"
    end

    describe "with custom OAuth URLs specified as URIs" do
      before :each do
        @instance = OAuth::Consumer.new \
          @consumer_key    = "consumer_key",
          @consumer_secret = "consumer_secret",
          :authorize_url     => @authorize_uri     = URI.parse("http://example.com/authorize"),
          :access_token_url  => @access_token_uri  = URI.parse("http://example.com/access_token"),
          :request_token_url => @request_token_uri = URI.parse("http://example.com/request_token")

        @authorize_url     = @authorize_uri.to_s
        @access_token_url  = @access_token_uri.to_s
        @request_token_url = @request_token_uri.to_s

        # URLs are too specific for paths to be sufficient
        @specific = true
      end

      # PENDING: doesn't handle URIs properly
      # it_should_behave_like "an OAuth::Consumer with known URLs"
    end
  end

  describe "#get_access_token" do
    before :each do
      @instance = OAuth::Consumer.new \
        @consumer_key    = "consumer_key",
        @consumer_secret = "consumer_secret"

      @request_token = stub "RequestToken", \
        :token  => "request_token",
        :secret => "request_token_secret"
    end

    it "should get an OAuth::AccessToken" do
      http = stub "Net::HTTP", \
        :address => "example.com",
        :port    => 80

      http_request = stub "Net::HTTP::POST", \
        :oauth! => true

      http_response = stub "Net::HTTPResponse", \
        :body    => "oauth_token=access_token&oauth_token_secret=access_token_secret",
        :code    => "200",
        :to_hash => {}

      @instance.expects(:create_http).with(nil).returns(http)
      @instance.expects(:create_http_request).with(:post, OAuth::Consumer::DEFAULT_ACCESS_TOKEN_PATH).returns(http_request)
      http.expects(:request).returns(http_response)

      access_token = @instance.get_access_token(@request_token)
      access_token.should be_a_kind_of(OAuth::AccessToken)
      access_token.token.should == "access_token"
      access_token.secret.should == "access_token_secret"
    end

    it "should get an OAuth::AccessToken containing extra parameters"
    it "should include extra parameters when requesting a token"
  end

  describe "#get_request_token" do
    before :each do
      @instance = OAuth::Consumer.new \
        @consumer_key    = "consumer_key",
        @consumer_secret = "consumer_secret",
        :site => "http://example.com"
    end

    it "should get an OAuth::RequestToken" do
      http = stub_everything "Net::HTTP", \
        :address       => "example.com",
        :port          => 80

      http_request = stub_everything("Net::HTTP::POST")

      http_response = stub "Net::HTTPResponse", \
        :body    => "oauth_token=request_token&oauth_token_secret=request_token_secret",
        :code    => "200",
        :to_hash => {}

      Net::HTTP.expects(:new).with("example.com", 80).returns(http)
      Net::HTTP::Post.expects(:new).with(OAuth::Consumer::DEFAULT_REQUEST_TOKEN_PATH, {}).returns(http_request)
      http.expects(:request).returns(http_response)

      request_token = @instance.get_request_token
      request_token.should be_a_kind_of(OAuth::RequestToken)
      request_token.token.should == "request_token"
      request_token.secret.should == "request_token_secret"
    end

    it "should get an OAuth::RequestToken containing extra parameters"
    it "should include extra parameters when requesting a token"
  end
end
