module OAuth
  # required parameters, per sections 6.1.1, 6.3.1, and 7
  PARAMETERS = %w(oauth_consumer_key oauth_token oauth_signature_method oauth_timestamp oauth_nonce oauth_version oauth_signature)

  # oauth_version is optional; oauth_token isn't required for 2-legged auth
  REQUIRED_PARAMETERS = %w(oauth_consumer_key oauth_signature_method oauth_timestamp oauth_nonce oauth_signature)

  # reserved character regexp, per section 5.1
  RESERVED_CHARACTERS = /[^\w\d\-\.\_\~]/
end
