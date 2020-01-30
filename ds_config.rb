class DSConfig

  # client_id is the same as Integrator Key
  @client_id = "{CLIENT_ID}"
  # The sender's email can't be used here.
  # This is the guid for the impersonated user (the sender).
  @impersonated_user_guid = "{IMPERSONATED_USER_ID}"
  @signer_email ="{SIGNER_EMAIL}"
  @signer_name ="{SIGNER_NAME}"
  @cc_email = "{CC_EMAIL}"
  @cc_name = "{CC_NAME}"
  
  # Use account.docusign.com for production
  @aud ="account-d.docusign.com"
  # If a target account is not specified then the user's default
  # account will be used
  @target_account_id = "FALSE"
  
  class << self
    attr_accessor :target_account_id
    attr_accessor :aud
    attr_accessor :client_id
    attr_accessor :impersonated_user_guid
    attr_accessor :signer_email
    attr_accessor :signer_name
    attr_accessor :cc_email
    attr_accessor :cc_name

  end
end
