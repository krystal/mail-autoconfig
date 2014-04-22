require 'nokogiri'

module MailAutoconfig
  class ClientConfig
    attr_reader :config

    def self.from_file(path)
      self.new(File.read(path))
    end

    def initialize(client_config_xml)
      @config = Nokogiri::XML(client_config_xml)
    end

    def provider
      @provider ||= config.xpath('//clientConfig/emailProvider')
    end

    def service_id
      @service_id ||= provider.attr('id').value
    end

    def name
      @name ||= provider.xpath('displayName').first.content
    end

    def short_name
      @short_name ||= provider.xpath('displayShortName').first.content
    end

  end
end