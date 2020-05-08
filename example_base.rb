require './ds_config'

class ExampleBase
  @@TOKEN_REPLACEMENT_IN_SECONDS = 10 * 60 # 10 minutes 
  @@TOKEN_EXPIRATION_IN_SECONDS = 60 * 60 # 1 hour 

  @@account = nil
  @@account_id = nil
  @@token = nil
  @@expireIn = 0
  @@private_key = nil

  class << self
    attr_accessor :account
    attr_accessor :account_id
    attr_accessor :token
    attr_accessor :expireIn
  end

  def initialize(client)
    @@api_client = client
  end

  def check_token
    @now = Time.now.to_f # seconds since epoch
    # Check that the token should be good
    if @@token == nil or ((@now + @@TOKEN_REPLACEMENT_IN_SECONDS) > @@expireIn)
      if @@token == nil
        puts "\nStarting up: fetching token"
      else
        puts "\nToken is about to expire: fetching token"
      end
      self.update_token
    end
  end

  def update_token
    rsa_pk = File.join(File.dirname(File.absolute_path(__FILE__)), 'docusign_private_key.txt')
    @@api_client.set_oauth_base_path(DSConfig.aud)
    token = @@api_client.request_jwt_user_token(DSConfig.client_id, DSConfig.impersonated_user_guid, rsa_pk)
    @@account = get_account_info(token.access_token)
    # puts @@account.to_yaml

    @@api_client.config.host = @@account.base_uri
    @@account_id = @@account.account_id
    @@token = token.access_token
    @@expireIn = Time.now.to_f + @@TOKEN_EXPIRATION_IN_SECONDS # would be better to receive the expires
    # info from DocuSign but it is not yet returned by the SDK.
    puts "Received token"
  end

  def get_account_info(access_token)
    # code here
    response = @@api_client.get_user_info(access_token)
    accounts = response.accounts
    target = DSConfig.target_account_id

    if target != nil and target != "FALSE"
      accounts.each do |acct|
        if acct.account_id == target
          return acct
        end
      end
      raise "The user does not have access to account #{target}"
    end

    accounts.find { |acct| acct.is_default == 'true' }
  end
end
