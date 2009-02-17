require 'oauth/client'
require 'oauth/consumer'
require 'oauth/helper'
require 'oauth/token'
require 'oauth/signature/hmac/sha1'

module OAuth
  module Client
    class Helper
      attr_reader :options, :request

      def initialize(request, options = {})
        @request = request
        @options = options
      end

      def nonce
        options[:nonce] ||= OAuth::Helper.generate_key
      end

      def timestamp
        options[:timestamp] ||= OAuth::Helper.generate_timestamp
      end

      def oauth_parameters
        {
          'oauth_consumer_key'     => options[:consumer].key,
          'oauth_token'            => options[:token] && options[:token].token || '',
          'oauth_signature_method' => options[:signature_method],
          'oauth_timestamp'        => timestamp,
          'oauth_nonce'            => nonce,
          'oauth_version'          => '1.0'
        }.reject { |k,v| v.to_s == "" }
      end

      def signature(extra_options = {})
        OAuth::Signature.sign(request, parameters_for_signing(extra_options))
      end

      def signature_base_string(extra_options = {})
        OAuth::Signature.signature_base_string(request, parameters_for_signing(extra_options))
      end

      def form_data
        parameters_with_oauth.merge(:oauth_signature => signature)
      end

      def header
        parameters = oauth_parameters
        parameters.merge!('oauth_signature' => signature)

        header_params_str = parameters.map { |k,v| "#{k}=\"#{OAuth::Helper.escape(v)}\"" }.join(', ')

        realm = "realm=\"#{options[:realm]}\", " if options[:realm]
        "OAuth #{realm}#{header_params_str}"
      end

      def path
        oauth_params_str = oauth_parameters.map { |k,v| [OAuth::Helper.escape(k), OAuth::Helper.escape(v)] * "=" } * "&"

        uri = URI.parse(request.path)
        uri.query = [uri.query, oauth_params_str].compact * "&"
        uri.query << "&oauth_signature=#{OAuth::Helper.escape(signature)}"

        uri.to_s
      end

      def parameters
        OAuth::RequestProxy.proxy(request).parameters
      end

      def parameters_with_oauth
        oauth_parameters.merge(parameters)
      end

    protected

      def parameters_for_signing(extra_parameters = {})
        {
          :uri        => options[:request_uri],
          :parameters => oauth_parameters
        }.merge(options).merge(extra_parameters)
      end
    end
  end
end
