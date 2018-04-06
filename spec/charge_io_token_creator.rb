require 'httparty'
class ChargeIOTokenCreator
  include HTTParty
  base_uri ENV['GATEWAY_URI']

  def initialize(public_key)
    @public_key = public_key
  end

  def create(options = {})
    response = self.class.post(
      '/v1/tokens',
      headers: { 'content-type' => 'application/json' },
      format: :json,
      basic_auth: { username: @public_key },
      body: {
        type: 'card',
        number: '4242424242424242',
        exp_month: 10,
        exp_year: 2019,
        cvv: 123,
        address1: '6200 Bridge Point',
        postal_code: 78730,
        email: 'rubyexample@affinipay.com'
      }.merge(options).to_json
    )
    # puts response.body, response.code, response.message, response.headers.inspect

    response.parsed_response.symbolize_keys
  end

end
