require "mail_autoconfig/version"
require "mail_autoconfig/client_config"


module MailAutoconfig

  def self.local_ispdb_path
    File.expand_path(File.join(__FILE__, "../", "ispdb_data"))
  end

  def self.ispdb_svn_url
    "http://svn.mozilla.org/mozillamessaging.com/sites/autoconfig.mozillamessaging.com/trunk"
  end

end
