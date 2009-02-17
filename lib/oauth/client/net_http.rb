require 'oauth/helper'
require 'oauth/client/helper'
require 'oauth/request_proxy/net_http'

module OAuth
  module Client
    module Net
      module HTTPRequest
        include OAuth::Helper

        attr_reader :oauth_helper

        def oauth!(http, consumer, token = nil, options = {})
          options = { :request_uri      => expand_uri(http),
                      :consumer         => consumer,
                      :token            => token,
                      :scheme           => :header,
                      :signature_method => "HMAC-SHA1",
                      :nonce            => nil,
                      :timestamp        => nil }.merge(options || {})

          @oauth_helper = OAuth::Client::Helper.new(self, options)

          case options[:scheme].to_sym
          when :header
            set_oauth_header
          when :body
            set_oauth_body
          when :query_string
            set_oauth_query_string
          else
            raise OAuth::Error, "Unsupported scheme: #{options[:scheme]}"
          end
        end

        def signature_base_string(http, consumer, token = nil, options = {})
          options = { :request_uri      => expand_uri(http),
                      :consumer         => consumer,
                      :token            => token,
                      :scheme           => :header,
                      :signature_method => "HMAC-SHA1",
                      :nonce            => nil,
                      :timestamp        => nil }.merge(options || {})

          OAuth::Client::Helper.new(self, options).signature_base_string
        end

      private

        def expand_uri(http)
          uri = URI.parse(self.path)
          uri.host = http.address
          uri.port = http.port

          if http.respond_to?(:use_ssl?) && http.use_ssl?
            uri.scheme = "https"
          else
            uri.scheme = "http"
          end

          uri.to_s
        end

        def set_oauth_header
          self['Authorization'] = oauth_helper.header
        end

        # FIXME: if you're using a POST body and query string parameters, using this
        # method will convert those parameters on the query string into parameters in
        # the body. this is broken, and should be fixed.
        def set_oauth_body
          self.form_data = oauth_helper.form_data
        end

        def set_oauth_query_string
          self.path = oauth_helper.path
        end
      end
    end
  end
end

Net::HTTPRequest.send(:include, OAuth::Client::Net::HTTPRequest)
