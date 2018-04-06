require_relative '../models_helper'
require_relative '../charge_io_token_creator'
require_relative '../spec_helper'
require 'json'

RSpec.describe MerchantInfo do
    it 'create' do
      merchant_info = MerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json)
      expect(JSON.parse(merchant_info.to_json)).to eq JSON.parse(TestStrings.merchant_info_json)
    end

    it 'create sanitized objects' do
      merchant_info = MerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json)
      expect(JSON.parse(merchant_info.sanitized.to_json)).to eq JSON.parse(TestStrings.accounts_json_sanitized)
    end

    it 'serialize/deserialize' do
      merchant_info = MerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json)
      file_content = ''
      File.open('test_merchant_info.json','w') do |s|
        s.puts merchant_info.to_json
      end
      File.open('test_merchant_info.json', 'r') do |f|
        f.each_line do |line|
          file_content = line
        end
      end
      expect(JSON.parse(file_content)).to eq JSON.parse(TestStrings.merchant_info_json)
    end

    it 'serialize/deserialize sanitized object' do
      merchant_info = MerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json).sanitized
      file_content = ''
      File.open('test_sanitized_merchant_info.json','w') do |s|
        s.puts merchant_info.to_json
      end
      File.open('test_sanitized_merchant_info.json', 'r') do |f|
        f.each_line do |line|
          file_content = line
        end
      end
      expect(JSON.parse(file_content)).to eq JSON.parse(TestStrings.accounts_json_sanitized)
    end
end

RSpec.describe StoredMerchantInfo, type: :controller do
  it 'create' do
    merchant_info = StoredMerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json, 'test_stored_merchant_info.json')
    merchant_info.save_to_file
    expect(JSON.parse(merchant_info.to_json)).to eq JSON.parse(TestStrings.merchant_info_json)
  end

  it 'store/load' do
    merchant_info = StoredMerchantInfo.new_w_json(TestStrings.access_token, TestStrings.accounts_json, 'test_stored_merchant_info.json')
    merchant_info.save_to_file
    stored_merchant_info = StoredMerchantInfo.new_w_filename('test_stored_merchant_info.json')
    stored_merchant_info.load_from_file
    expect(stored_merchant_info.to_json).to eq merchant_info.to_json
  end

end
