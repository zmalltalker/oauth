require 'oauth/signature/hmac/base'
require 'hmac-sha2' unless RUBY_VERSION > '1.9'

module OAuth::Signature::HMAC
  class SHA2 < Base
    implements 'hmac-sha2'
    digest_class RUBY_VERSION > '1.9' ? ::Digest::SHA2 : ::HMAC::SHA2
  end
end
