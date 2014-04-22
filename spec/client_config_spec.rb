require 'mail_autoconfig'

describe MailAutoconfig::ClientConfig do

  context "from static config" do
    let(:client_config) { MailAutoconfig::ClientConfig.from_file(File.expand_path(File.join(__FILE__, '../', 'examples', 'client_config_yahoo.xml'))) }

    it "reads a service name" do
      client_config.name.should == "Yahoo! Mail"
    end
    
    it "reads a short name" do
      client_config.short_name.should == "Yahoo"
    end

    it "reads service id" do
      client_config.service_id.should == "yahoo.com"
    end
  end

end