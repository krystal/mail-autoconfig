module MailAutoconfig

  # Email address that we're going to investigate
  class EmailAddress
    attr_reader :address

    # @param address [String] the email address to look up
    def initialize(address)
      @address = address
    end

    # Fetch the client configuration for this email address.
    # First of all try the domain determined by {#domain}. If nothing is found there,
    # check the domain specified in {#primary_mx_domain}. Returns false if none found.
    # @return [MailAutoconfig::ClientConfig] the client configuration for this address
    def client_config
      @client_config ||= begin
        config = MailAutoconfig::ClientConfig.search(domain)
        config ||= MailAutoconfig::ClientConfig.search(primary_mx_domain)
        config.email_address = self if config
        config
      end
    end

    # The local part of the emai address (before the @ symbol).
    # Useful for usage with the %EMAILLOCALPART% substitution.
    # @return [String] the local part of the email address
    def local_part
      @local_part ||= @address.split('@', 2).first
    end

    # The domain of the email address (the part after the @ symbol)
    # @return [String] the domain of the email address
    def domain
      @domain ||= @address.split('@', 2).last
    end
  
    # Finds the primary MX domain for this address. Would change gmail-smtp-in.l.google.com to google.com
    # @return [String] the domain of the pimary MX record for this address
    def primary_mx_domain
      @primary_mx_domain ||= begin 
        # Not very nice to 2nd level domains
        mx_records.first.split(".")[-2..-1].join(".") unless mx_records.empty?
      end
    end

    private

    # Finds MX records for the associated email address, ordered by preference.
    # @return [Array] MX records for this email address
    def mx_records
      @mx_records ||= Resolv::DNS.open.getresources(domain, Resolv::DNS::Resource::IN::MX).sort_by(&:preference).map{ |r| r.exchange.to_s }
    end

  end
end