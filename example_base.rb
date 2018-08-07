require './ds_config'

class ExampleBase
  @@TOKEN_REPLACEMENT_IN_MILLISECONDS = 10 * 60 * 1000
  @@TOKEN_EXPIRATION_IN_SECONDS = 3600

  @@account = nil
  @@account_id = nil
  @@token = nil
  @@expireIn = 0

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
    @now = Time.now.to_f * 1000
    if @@token == nil and (@now + @@TOKEN_REPLACEMENT_IN_MILLISECONDS) > @@expireIn
        self.update_token
    end
  end

  def update_token
    path = File.join(File.dirname(File.absolute_path(__FILE__)), 'docusign_private_key.txt')

    token = @@api_client.configure_jwt_authorization_flow(path,
                                                  DSConfig.aud,
                                                  DSConfig.client_id,
                                                  DSConfig.impersonated_user_guid, 3600)

    if @@account == nil
      @@account = get_account_info()
    end

    @@api_client.config.host = @@account[:base_uri]
    @@account_id = @@account[:account_id]
    # token[0..6] = ''
    @@token = token
  end

  def get_account_info
    # code here
    response = @@api_client.call_api("GET","https://account-d.docusign.com/oauth/userinfo", {return_type:"Object"})

    if response.length > 1 and !(200..299).include?response[1]
      raise 'can not get user info: %d' % response[1]
    end

    accounts = response[0][:accounts]
    target = DSConfig.target_account_id

    if target != nil and target != "FALSE"
      accounts.each do |acct|
        if acct[:account_id] == target
          return acct
        end
      end
    end

    accounts.each do |acct|
      if acct[:is_default]
        return acct
      end
    end


  end

end
