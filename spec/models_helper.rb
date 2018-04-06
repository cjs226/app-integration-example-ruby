require_relative '../app/models/account'
require_relative  '../app/models/merchant_info'
require_relative  '../app/models/stored_merchant_info'

class TestStrings
  class << self; attr_reader :access_token end
  class << self; attr_reader :account1_json end
  class << self; attr_reader :account2_json end
  class << self; attr_reader :account3_json end
  class << self; attr_reader :accounts_json end
  class << self; attr_reader :account1_json_sanitized end
  class << self; attr_reader :account2_json_sanitized end
  class << self; attr_reader :account3_json_sanitized end
  class << self; attr_reader :accounts_json_sanitized end

  class << self; attr_reader :merchant_info_json end
  @access_token = '000'
  @account1_json = '{"id":"1","name":"2","type":"3","currency":"4","public_key":"5","secret_key":"6","trust_account":false}'
  @account2_json = '{"id":"l1","name":"l2","type":"l3","currency":"l4","public_key":"l5","secret_key":"l6","trust_account":false}'
  @account3_json = '{"id":"l1_2","name":"l2_2","type":"l3_2","currency":"l4_2","public_key":"l5_2","secret_key":"l6_2","trust_account":true}'
  @accounts_json = "{\"test_accounts\": [#{@account1_json}] ,\"live_accounts\":[#{@account2_json}, #{@account3_json}]}"
  @merchant_info_json = "{\"access_token\": \"#{@access_token}\" ,\"test_accounts\": [#{@account1_json}] ,\"live_accounts\":[#{@account2_json}, #{@account3_json}]}"
  @account1_json_sanitized = '{"id":"1","name":"2","type":"3","currency":"4","public_key":"5","trust_account":false}'
  @account2_json_sanitized = '{"id":"l1","name":"l2","type":"l3","currency":"l4","public_key":"l5","trust_account":false}'
  @account3_json_sanitized = '{"id":"l1_2","name":"l2_2","type":"l3_2","currency":"l4_2","public_key":"l5_2","trust_account":true}'
  @accounts_json_sanitized = "{\"test_accounts\": [#{@account1_json_sanitized}] ,\"live_accounts\":[#{@account2_json_sanitized}, #{@account3_json_sanitized}]}"
end
