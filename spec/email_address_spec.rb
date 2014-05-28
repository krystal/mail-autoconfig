require 'mail_autoconfig'

describe MailAutoconfig::EmailAddress do

  context 'example@gmail.com' do
    let(:address) { MailAutoconfig::EmailAddress.new('example@gmail.com') }

    it 'should have a gmail domain' do
      expect(address.domain).to eq('gmail.com')
    end

    it 'should have a local part' do
      expect(address.local_part).to eq('example')
    end

    it 'should have gmail MX domains' do
      expect(address.primary_mx_domain).to eq("google.com")
    end

    it 'should have a client config' do
      expect(address.client_config).to be_a(MailAutoconfig::ClientConfig)
    end

    it 'should have GMail as client config provider short name' do
      expect(address.client_config.short_name).to eq('GMail')
    end
  end

  context 'example@atechmedia.com' do
    let(:address) { MailAutoconfig::EmailAddress.new('example@atechmedia.com') }
    it 'should not have a detectable configuration' do
      expect(address.client_config).to be_false
    end
  end

  context 'example@swcp.com' do
    let(:address) { MailAutoconfig::EmailAddress.new('example@swcp.com') }
    it 'should have an autoconf configuration' do
      expect(address.client_config).to be_a(MailAutoconfig::ClientConfig)
    end
  end

  context 'example@veryunlikelydomain4567763332.com' do
    let(:address) { MailAutoconfig::EmailAddress.new('example@veryunlikelydomain4567763332.com') }
    it 'should not return a configuration' do
      expect(address.client_config).to be_false
    end

    it 'should not have a primary mx domain' do
      expect(address.primary_mx_domain).to be_nil
    end
  end
end