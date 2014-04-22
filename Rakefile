require "bundler/gem_tasks"
require "mail_autoconfig"

desc "Checkout the latest copy of the mozilla ispdb"
task :fetch_ispdb do
  svn_url = MailAutoconfig.ispdb_svn_url
  local_path = MailAutoconfig.local_ispdb_path
  puts "Exporting..."
  `svn export --force #{svn_url} #{local_path}`
  `rm #{local_path}/README`
end