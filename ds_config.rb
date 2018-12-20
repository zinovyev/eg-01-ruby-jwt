class DSConfig

  # client_id is the same as Integrator Key
  @client_id = "{CLIENT_ID"
  # In the future, the SDK will accept the private key as a string.
  # Currently, the SDK wants a filename where the file includes the 
  # private key. For this example, store the private key in
  # file |docusign_private_key.txt|

  # The sender's email can't be used here.
  # This is the guid for the impersonated user (the sender).
  @impersonated_user_guid = "{IMPERSONATED_GUID}"
  @signer_email ='{USER_EMAIL}'
  @signer_name ='{USER_FULLNAME}'
  @cc_email = '{CC_EMAIL}'
  @cc_name = '{CC_FULLNAME}'
  
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
