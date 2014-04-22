require 'mail_autoconfig'

describe MailAutoconfig::ClientConfig do

  context "from static config" do
    let(:client_config) { MailAutoconfig::ClientConfig.from_file(File.expand_path(File.join(__FILE__, '../', 'examples', 'client_config_yahoo.xml'))) }

    it "reads a service name" do
      expect(client_config.name).to eq("Yahoo! Mail")
    end
    
    it "reads a short name" do
      expect(client_config.short_name).to eq("Yahoo")
    end

    it "reads provider id" do
      expect(client_config.provider_id).to eq("yahoo.com")
    end

    it "reads domain aliases" do
      expect(client_config.domains).to include('yahoo.com', 'yahoo.co.uk')
    end

    it 'matches valid domains' do
      expect(client_config.valid_for_domain?('yahoo.it')).to be(true)
    end

    it "doesn't match invalid domains" do
      expect(client_config.valid_for_domain?('googlemail.com')).to be(false)
    end
  end


  context "automatically detects domains" do
    it "from local files" do
      expect(MailAutoconfig::ClientConfig.search_local_files("googlemail.com")).to be_a(MailAutoconfig::ClientConfig)
    end

    it "from local files with an alias domain" do
      expect(MailAutoconfig::ClientConfig.search_local_files("gmail.com")).to be_a(MailAutoconfig::ClientConfig)
    end

    it "from an autoconfig domain" do
      expect(MailAutoconfig::ClientConfig.search_autoconfig_domain("swcp.com")).to be_a(MailAutoconfig::ClientConfig)
    end
  end

end