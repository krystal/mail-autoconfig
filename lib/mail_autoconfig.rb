require 'nokogiri'
require 'faraday'
require 'resolv'

require "mail_autoconfig/version"
require "mail_autoconfig/client_config"
require "mail_autoconfig/server"
require "mail_autoconfig/email_address"

# Module to lookup mailbox autoconfiguration according to Thunderbird 
# spec (https://wiki.mozilla.org/Thunderbird:Autoconfiguration:ConfigFileFormat)
# and guidelines (https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration)
module MailAutoconfig

  # The path for the locally stored Thunderbird ISPDB configurations
  # @return [String] absolute path to the ispdb data directory
  def self.local_ispdb_path
    File.expand_path(File.join(__FILE__, "../", "../", "ispdb_data"))
  end

  # The URL to the canonical SVN repository containing the Thunderbird IPSDB
  # @return [String] SVN repository location
  def self.ispdb_svn_url
    "http://svn.mozilla.org/mozillamessaging.com/sites/autoconfig.mozillamessaging.com/trunk"
  end

  # Fetch the client configuration for a given email address, if any.
  # Returns false if none found.
  # @param email [String] the email address to lookup
  # @return [MailAutoconfig::ClientConfig]
  def self.for_address(email)
    MailAutoconfig::EmailAddress.new(email).client_config
  end

end
