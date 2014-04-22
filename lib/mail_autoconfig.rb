require 'nokogiri'
require 'faraday'
require 'resolv'

require "mail_autoconfig/version"
require "mail_autoconfig/client_config"
require "mail_autoconfig/server"
require "mail_autoconfig/email_address"

module MailAutoconfig

  def self.local_ispdb_path
    File.expand_path(File.join(__FILE__, "../", "../", "ispdb_data"))
  end

  def self.ispdb_svn_url
    "http://svn.mozilla.org/mozillamessaging.com/sites/autoconfig.mozillamessaging.com/trunk"
  end

  def self.for_address(email)
    MailAutoconfig::EmailAddress.new(email).client_config
  end

end
