module MailAutoconfig

  # Superclass for {IncomingServer} and {OutgoingServer}.
  # Never used directly.
  class Server
    attr_reader :config
    attr_reader :client_config

    # @param config [Nokogiri::XML::Node] an XML representation of this server
    def initialize(config, client_config)
      @config = config
      @client_config = client_config
    end

    # Returns the protocol of the mail server e.g. `smtp`, `pop3`, `imap`
    # @return [String] The protocol for the server
    def protocol
      @protocol ||= config.attr('type')
    end

    # @return [String] The hostname for this server
    def hostname
      @hostname ||= config.xpath('hostname').first.content
    end

    # @return [Integer] The port to connect ot this server on
    def port
      @port ||= config.xpath('port').first.content.to_i
    end

    # The connection type for this server. `plain`, `STARTTLS`, `SSL` are acceptable
    # @return [String] The connection type
    def socket_type
      @socket_type ||= config.xpath('socketType').first.content
    end

    # The username for this mailbox, combines {username_format} and [EmailAddress] details
    # @return [String] The username
    def username
      return @username if @username

      @username = username_format
      @username.gsub! '%EMAILADDRESS%', client_config.email_address.address
      @username.gsub! '%EMAILLOCALPART%', client_config.email_address.local_part
      @username.gsub! '%EMAILDOMAIN%', client_config.email_address.domain
      @username
    end

    # Return the username format for this server. There are substitutions that can be made.
    #
    # * `%EMAILADDRESS%` - full email address of the user, usually entered by the user
    # * `%EMAILLOCALPART%` - email address, part before @
    # * `%EMAILDOMAIN%` - email address, part after @
    #
    # @return [String] the username format
    def username_format
      @username_format ||= config.xpath('username').first.content
    end

    # The authentication type for this server. Valid responses:
    # `password-cleartext`, `NTLM`, `GSSAPI`, `client-IP-address`, `TLS-client-cert`, `none`
    # @return [String] the authentication method for this server
    def authentication
      @authentication ||= config.xpath('authentication').first.content
    end
  end

  # Configuration details for an incoming server.
  class IncomingServer < Server; end

  # Configuration details for an outgoing server.
  class OutgoingServer < Server; end
end