require 'oauth/signature/hmac/base'
require 'hmac-sha1' unless RUBY_VERSION > '1.9'

module OAuth::Signature::HMAC
  class SHA1 < Base
    implements 'hmac-sha1'
    digest_class RUBY_VERSION > '1.9' ? ::Digest::SHA1 : ::HMAC::SHA1
  end
end
