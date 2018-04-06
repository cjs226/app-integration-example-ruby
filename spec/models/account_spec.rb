require_relative '../models_helper'

RSpec.describe Account do

    it 'create' do
      test_account = Account.json_create(JSON.parse(TestStrings.account1_json))
      expect(test_account.id).to eq '1'
      expect(JSON.parse(test_account.to_json)).to eq JSON.parse(TestStrings.account1_json)
   end

    it 'serialize' do
      test_account = Account.json_create(JSON.parse(TestStrings.account1_json))
      file_content = ''
      File.open('test_account.out','w') do |s|
        s.puts test_account.to_json
      end
      File.open('test_account.out', 'r') do |f|
        f.each_line do |line|
          file_content = line
        end
      end
      expect(JSON.parse(file_content)).to eq JSON.parse(TestStrings.account1_json)
    end

end