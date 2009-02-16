require File.join(File.dirname(__FILE__), "spec_helper")
require "shared_net_http_client_examples"

describe OAuth::Client::Net::HTTPRequest do
  before :all do
    # TODO convert either into an RSpec Matcher or a Mocha parameter matcher
    @require_oauth_parameters = lambda { |value|
      value =~ /oauth_consumer_key=/ &&
        value =~ /oauth_signature_method=/ &&
        value =~ /oauth_timestamp=/ &&
        value =~ /oauth_nonce=/ &&
        value =~ /oauth_signature=/
    }
  end

  before :each do
    @instance = stub("HTTPRequest")
    @instance.class.class_eval do
      include OAuth::Client::Net::HTTPRequest
    end
  end

  describe "#oauth!" do
    before :each do
      @instance.stubs(:method).returns("GET")
      @instance.stubs(:path).with.returns("/resource")
      @instance.stubs(:[])

      @consumer = stub "Consumer", \
        :key    => "consumer_key",
        :secret => "consumer_secret"

      @http = stub "Net::HTTP", \
        :address => "example.com",
        :port    => 80
    end

    describe "with defaults" do
      it_should_behave_like "#oauth! using the 'header' scheme"
    end

    describe "using the 'header' scheme" do
      before :each do
        @options = {
          :scheme => :header
        }
      end

      it_should_behave_like "#oauth! using the 'header' scheme"
    end

    describe "using the 'query_string' scheme" do
      before :each do
        @options = {
          :scheme => :query_string
        }
      end

      it "should include OAuth parameters in the querystring" do
        @instance.expects(:path=).with { |path|
          @require_oauth_parameters.call(path)
        }

        @instance.oauth!(@http, @consumer, nil, @options)
      end

      it "should not include an 'oauth_token' parameter" do
        @instance.expects(:path=).with { |path|
          path !~ /oauth_token=/
        }

        @instance.oauth!(@http, @consumer, nil, @options)
      end

      describe "and a token" do
        before :each do
          @token = stub "OAuth::Token", \
            :token  => "token",
            :secret => "secret"
        end

        it "should include an 'oauth_token' parameter" do
          @instance.expects(:path=).with { |path|
            path =~ /oauth_token=/
          }

          @instance.oauth!(@http, @consumer, @token, @options)
        end
      end
    end

    describe "using the 'body' scheme" do
      before :each do
        @options = {
          :scheme => :body
        }
      end

      it "should include OAuth parameters in the body" do
        @instance.expects(:form_data=).with { |hash|
          # convert the hash into x-www-form-urlencoded
          @require_oauth_parameters.call(hash.to_a.map { |x| x * "=" } * "&")
        }

        @instance.oauth!(@http, @consumer, @token, @options)
      end

      it "should not include an 'oauth_token' parameter" do
        @instance.expects(:form_data=).with { |hash|
          !hash.has_key?("oauth_token")
        }

        @instance.oauth!(@http, @consumer, nil, @options)
      end

      describe "and a token" do
        before :each do
          @token = stub "OAuth::Token", \
            :token  => "token",
            :secret => "secret"
        end

        it "should include an 'oauth_token' parameter" do
          @instance.expects(:form_data=).with { |hash|
            hash.has_key?("oauth_token")
          }

          @instance.oauth!(@http, @consumer, @token, @options)
        end
      end
    end
  end
end
