require 'oauth/signature/hmac/base'
require 'hmac-rmd160' unless RUBY_VERSION > '1.9'

module OAuth::Signature::HMAC
  class RMD160 < Base
    implements 'hmac-rmd160'
    digest_class RUBY_VERSION > '1.9' ? ::Digest::RMD160 : ::HMAC::RMD160
  end
end
