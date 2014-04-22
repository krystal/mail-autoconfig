require "bundler/gem_tasks"

desc "Checkout the latest copy of the mozilla ispdb"
task :fetch_ispdb do
  svn_url = "http://svn.mozilla.org/mozillamessaging.com/sites/autoconfig.mozillamessaging.com/trunk"
  local_path = File.expand_path(File.join(__FILE__, '../' 'ispdb_data'))
  puts `svn export --force #{svn_url} #{local_path}`
  `rm #{local_path}/README`
end