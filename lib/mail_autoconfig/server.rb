module MailAutoconfig
  class Server
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def protocol
      @protocol ||= config.attr('type')
    end

    def hostname
      @hostname ||= config.xpath('hostname').first.content
    end

    def port
      @port ||= config.xpath('port').first.content.to_i
    end

    def socket_type
      @socket_type ||= config.xpath('socketType').first.content
    end

    def username
      @username ||= config.xpath('username').first.content
    end

    def authentication
      @authentication ||= config.xpath('authentication').first.content
    end
  end

  class IncomingServer < Server; end
  class OutgoingServer < Server; end
end