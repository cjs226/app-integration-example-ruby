require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app/demoApi.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x and 3.x
RSpec.configure do |c|
  c.include RSpecMixin
  # c.after(:suite) do # or :each or :all
  #   File.delete("test_merchant_info.json")
  #   File.delete("test_sanitized_merchant_info.json")
  #   File.delete("test_stored_merchant_info.json")
  # end
end
