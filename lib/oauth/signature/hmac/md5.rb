require 'oauth/signature/hmac/base'
require 'hmac-md5' unless RUBY_VERSION > '1.9'

module OAuth::Signature::HMAC
  class MD5 < Base
    implements 'hmac-md5'
    digest_class digest_class RUBY_VERSION > '1.9' ? ::Digest::MD5 : ::HMAC::MD5
  end
end
