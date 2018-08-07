class DSConfig

  #### Copy this file to ds_config.rb and update it.
  #### ds_config.rb is in .gitignore so it will NOT be stored in git

  # Use account.docusign.com for production
  @aud ="account-d.docusign.com"
  # client_id is the same as Integrator Key
  @client_id = "123"
  # The user's email can't be used here:
  @impersonated_user_guid = "456"
  # If a target account is not specified then the user's default
  # account will be used
  @target_account_id = "FALSE"
  @signer_email ='pat@example.com'
  @signer_name ='Pat Marshall'
  @cc_email = 'sam@example.com'
  @cc_name = 'Sam Spade'

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
