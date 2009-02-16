module OAuth
  # The RequestToken is used for the initial Request.
  # This is normally created by the Consumer object.
  class RequestToken < ConsumerToken

    # Generate an authorization URL for user authorization
    def authorize_url(params = nil)
      params = (params || {}).merge(:oauth_token => self.token)
      build_authorize_url(consumer.authorize_url, params)
    end

    # exchange for AccessToken on server
    def get_access_token(options = {})
      consumer.get_access_token(self, options)
    end

  protected

    # construct an authorization url
    def build_authorize_url(base_url, params)
      uri = URI.parse(base_url.to_s)

      uri.query = params.map do |k,v|
        v.collect do |val|
          [k, CGI.escape(val)] * "="
        end * "&"
      end * "&"

      uri.to_s
    end
  end
end
