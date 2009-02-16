share_examples_for "#oauth! using the 'header' scheme" do
  it "should create an OAuth Authorization header" do
    @instance.expects(:[]=).with { |k, v|
      k == "Authorization" &&
      v =~ /^OAuth/
    }

    @instance.oauth!(@http, @consumer, nil, @options)
  end

  it "should not include a 'realm' parameter in the Authorization header" do
    @instance.expects(:[]=).with { |k, v|
      k == "Authorization" &&
        v =~ /^OAuth/ &&
        v !~ /realm/
    }

    @instance.oauth!(@http, @consumer, nil, @options)
  end

  it "should not include an 'oauth_token' parameter in the Authorization header" do
    @instance.expects(:[]=).with { |k, v|
      k == "Authorization" &&
        v =~ /^OAuth/ &&
        v !~ /oauth_token/
    }

    @instance.oauth!(@http, @consumer, nil, @options)
  end

  it "should include required OAuth parameters" do
    @instance.expects(:[]=).with { |k, v|
      @require_oauth_parameters.call(v)
    }

    @instance.oauth!(@http, @consumer, nil, @options)
  end

  describe "and a token" do
    before :each do
      @token = stub "OAuth::Token", \
        :token  => "token",
        :secret => "secret"
    end

    it "should include an 'oauth_token' parameter in the Authorization header" do
      @instance.expects(:[]=).with { |k, v|
        k == "Authorization" &&
          v =~ /^OAuth/ &&
          v =~ /oauth_token/
      }

      @instance.oauth!(@http, @consumer, @token, @options)
    end
  end
end
