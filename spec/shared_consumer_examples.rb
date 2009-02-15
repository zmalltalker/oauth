# Provide the :site parameter as:
#  @site
share_examples_for "an OAuth::Consumer with a :site parameter" do
  before :each do
    @site.should_not be_nil

    # default paths if they weren't set
    @authorize_path     ||= OAuth::Consumer::DEFAULT_AUTHORIZE_PATH
    @access_token_path  ||= OAuth::Consumer::DEFAULT_ACCESS_TOKEN_PATH
    @request_token_path ||= OAuth::Consumer::DEFAULT_REQUEST_TOKEN_PATH

    # generate urls
    @authorize_url     = [@site, @authorize_path].join
    @access_token_url  = [@site, @access_token_path].join
    @request_token_url = [@site, @request_token_path].join
  end

  it "site should be set" do
    @instance.site.should == @site
  end

  it_should_behave_like "an OAuth::Consumer with known paths"
  it_should_behave_like "an OAuth::Consumer with known URLs"
end

# Provide paths as:
#  @authorize_path
#  @access_token_path
#  @request_token_path
share_examples_for "an OAuth::Consumer with known paths" do
  it "authorize_path should be known" do
    @instance.authorize_path.should == @authorize_path
  end

  it "access_token_path should be known" do
    @instance.access_token_path.should == @access_token_path
  end

  it "request_token_path should be known" do
    @instance.request_token_path.should == @request_token_path
  end
end

# Provide URLs as:
#  @authorize_url
#  @access_token_url
#  @request_token_url
#
# If the known URLs are specific (i.e. paths are insufficient), set
#  @specific = true
share_examples_for "an OAuth::Consumer with known URLs" do
  it "authorize_url should be known" do
    @instance.authorize_url.should == @authorize_url
  end

  it "access_token_url should be known" do
    @instance.access_token_url.should == @access_token_url
  end

  it "request_token_url should be known" do
    @instance.request_token_url.should == @request_token_url
  end

  it "authorize_path should be nil" do
    if @specific
      pending("the path is not specific enough to be accurate") do
        @instance.authorize_path.should be_nil
      end
    end
  end

  it "access_token_url should be nil" do
    if @specific
      pending("the path is not specific enough to be accurate") do
        @instance.access_token_path.should be_nil
      end
    end
  end

  it "request_token_url should be nil" do
    if @specific
      pending("the path is not specific enough to be accurate") do
        @instance.request_token_path.should be_nil
      end
    end
  end
end

share_examples_for "an OAuth::Consumer without a :site parameter" do
  it "authorize_url should be nil" do
    pending("without a :site parameter, a url can't be generated") do
      @instance.authorize_url.should be_nil
    end
  end

  it "access_token_url should be nil" do
    pending("without a :site parameter, a url can't be generated") do
      @instance.access_token_url.should be_nil
    end
  end

  it "request_token_url should be nil" do
    pending("without a :site parameter, a url can't be generated") do
      @instance.request_token_url.should be_nil
    end
  end
end
