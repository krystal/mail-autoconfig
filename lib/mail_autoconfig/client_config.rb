module MailAutoconfig

  # Parse the Autoconfig XML file and create a ruby representation
  class ClientConfig

    attr_reader :config
    attr_accessor :email_address

    class << self
      # Build a configuration from the specified path
      # @param path [String] the loction of the client configuartion file
      # @return [ClientConfig] new client configuration 
      def from_file(path)
        self.new(File.read(path))
      end

      # Try to find a configuration for the given domain, locally or remotely
      # @param domain [String] the domain to lookup the configuration for
      # @return [ClientConfig] client configuration for the domain
      def search(domain)
        search_local_files(domain) || search_autoconfig_domain(domain)
      end

      # Search local ISPDB for configurations matching the domain
      # @param domain [String] the domain to look for
      # @return [ClientConfig] client configuration for the domain
      def search_local_files(domain)
        last_config = false
        match = Dir.glob(File.join(MailAutoconfig.local_ispdb_path, '*')).find do |config_file|
          last_config = self.from_file(config_file)
          last_config.valid_for_domain?(domain)
        end
        match ? last_config : false
      end

      # Try a remote server for the configuration for the domain.
      # Search `http://autoconfig.#{domain}/mail/config-v1.1.xml` first,
      # followed by `http://#{domain}/.well-known/autoconfig/mail/config-v1.1.xml`
      # @param domain [String] the domain to look for
      # @return [ClientConfig] the client configuration for the domain
      def search_autoconfig_domain(domain)
        last_config = false
        match = ["http://autoconfig.#{domain}/mail/config-v1.1.xml", "http://#{domain}/.well-known/autoconfig/mail/config-v1.1.xml"].find do |url|
          begin
            response = Faraday.get(url)
            if response.status == 200
              last_config = self.new(response.body)
            else
              false
            end
          rescue
            false
          end
        end
        match ? last_config : false
      end
    end

    # @param client_config_xml [String] the raw XML to build the ClientConfig from.
    def initialize(client_config_xml)
      @config = Nokogiri::XML(client_config_xml)
    end

    # A list of domain aliases that this configuration applies to 
    # @return [Array] list of domains for this configuration
    def domains
      @domains ||= provider.xpath('domain').map {|domain| domain.content }
    end

    # Does this configuration file apply to the specified domain?
    # @param domain [String] the domain to check
    # @return [Boolean] Does the domain match?
    def valid_for_domain?(domain)
      domains.any? {|d| d == domain}
    end

    # @return [String] The unique string identifying this service (e.g. googlemail.com)
    def provider_id
      @provider_id ||= provider.attr('id').value
    end

    # @return [String] the full name of this service (e.g. Google Mail)
    def name
      @name ||= provider.xpath('displayName').first.content
    end

    # @return [String] the short name of this service (e.g. GMail)
    def short_name
      @short_name ||= provider.xpath('displayShortName').first.content
    end

    # The incoming servers for this configuration. There can be multiple servers per
    # configuration e.g. for IMAP and POP3, ordered in list of preference.
    # @return [Array] list of incoming servers
    def incoming_servers
      @incoming_servers ||= provider.xpath('incomingServer').map do |incoming|
        MailAutoconfig::IncomingServer.new(incoming, self)
      end
    end
    
    # The outgoing servers for this configuration. There can be multiple servers per
    # configuration, ordered in list of preference.
    # @return [Array] list of outgoing servers
    def outgoing_servers
      @outgoing_servers ||= provider.xpath('outgoingServer').map do |outgoing|
        MailAutoconfig::OutgoingServer.new(outgoing, self)
      end
    end

    private

    # @return [Nokogiri::XML::Node] the root configuration node
    def provider
      @provider ||= config.xpath('//clientConfig/emailProvider')
    end

  end
end