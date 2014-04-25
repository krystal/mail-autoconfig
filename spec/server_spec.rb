require 'mail_autoconfig'

describe MailAutoconfig::Server do

  context "static config" do
    let(:client_config) { MailAutoconfig::ClientConfig.from_file(File.expand_path(File.join(__FILE__, '../', 'examples', 'client_config_yahoo.xml'))) }

    context "from incoming_server" do
      let(:server) { client_config.incoming_servers.first }

      it "is an incoming server" do
        expect(server).to be_a(MailAutoconfig::IncomingServer)
      end

      it "is a pop3 server" do
        expect(server.protocol).to eq('pop3')
      end

      it "has a hostname" do
        expect(server.hostname).to eq('pop.mail.yahoo.com')
      end

      it "has a port" do
        expect(server.port).to eq(995)
      end

      it "has a socket type" do
        expect(server.socket_type).to eq('SSL')
      end

      it "has a username format" do
        expect(server.username_format).to eq('%EMAILADDRESS%')
      end

      it "can process a username from the format" do
        client_config.email_address = MailAutoconfig::EmailAddress.new('example@gmail.com')
        expect(server.username).to eq('example@gmail.com')
      end

      it "has an authentication method" do
        expect(server.authentication).to eq('password-cleartext')
      end
    end

    context "from outgoing server" do
      let(:server) { client_config.outgoing_servers.first }

      it "is an outgoing server" do
        expect(server).to be_a(MailAutoconfig::OutgoingServer)
      end

      it "is an smtp server" do
        expect(server.protocol).to eq('smtp')
      end

      it "has a hostname" do
        expect(server.hostname).to eq('smtp.mail.yahoo.com')
      end

      it "has a port" do
        expect(server.port).to eq(465)
      end

      it "has a socket type" do
        expect(server.socket_type).to eq('SSL')
      end

      it "has a username format" do
        expect(server.username_format).to eq('%EMAILADDRESS%')
      end

      it "can process a username from the format" do
        client_config.email_address = MailAutoconfig::EmailAddress.new('example@gmail.com')
        expect(server.username).to eq('example@gmail.com')
      end

      it "has an authentication method" do
        expect(server.authentication).to eq('password-cleartext')
      end
    end

  end

end