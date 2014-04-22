module MailAutoconfig

  class EmailAddress
    
    def initialize(address)
      @address = address
    end

    def client_config
      return @client_config if @client_config
      
      @client_config = MailAutoconfig::ClientConfig.search(domain)
      unless @client_config
        primary_mx_domain = mx_records.first.split(".")[-2..-1].join(".") # Not very nice to 2nd level domains
        @client_config = MailAutoconfig::ClientConfig.search(primary_mx_domain)
      end
      
      @client_config
    end

    def local_part
      @local_part ||= @address.split('@', 2).first
    end

    def domain
      @domain ||= @address.split('@', 2).last
    end

    def mx_records
      @mx_records ||= Resolv::DNS.open.getresources(domain, Resolv::DNS::Resource::IN::MX).sort_by(&:preference).map{ |r| r.exchange.to_s }
    end
  
  end

end