require 'nokogiri'
require 'faraday'

module MailAutoconfig
  class ClientConfig

    attr_reader :config

    def initialize(client_config_xml)
      @config = Nokogiri::XML(client_config_xml)
    end

    def domains
      @domains ||= provider.xpath('domain').map {|domain| domain.content }
    end

    def valid_for_domain?(domain)
      domains.any? {|d| d == domain}
    end

    def provider
      @provider ||= config.xpath('//clientConfig/emailProvider')
    end

    def provider_id
      @provider_id ||= provider.attr('id').value
    end

    def name
      @name ||= provider.xpath('displayName').first.content
    end

    def short_name
      @short_name ||= provider.xpath('displayShortName').first.content
    end

    class << self
      def from_file(path)
        self.new(File.read(path))
      end

      def search_local_files(domain)
        last_config = false
        match = Dir.glob(File.join(MailAutoconfig.local_ispdb_path, '*')).find do |config_file|
          last_config = self.from_file(config_file)
          last_config.valid_for_domain?(domain)
        end
        match ? last_config : false
      end

      def search_autoconfig_domain(domain)
        last_config = false
        match = ["http://autoconfig.#{domain}/mail/config-v1.1.xml", "http://#{domain}/.well-known/autoconfig/mail/config-v1.1.xml"].find do |url|
          response = Faraday.get(url)
          if response.status == 200
            last_config = self.new(response.body)
          else
            false
          end
        end
        match ? last_config : false
      end
    end

  end
end