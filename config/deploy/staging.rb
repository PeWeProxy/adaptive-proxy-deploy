set :deploy_to, "/home/peweproxy/release"
set :repository,  "git://gitbus.fiit.stuba.sk/pewe-proxy-team-project/adaptive-proxy-deploy.git"
#stage-specific, moved to config/deploy/staging and config/deploy/production.rb
#set :deploy_to, "/var/rails/#{application}"
server "peweproxy-staging.fiit.stuba.sk", :app, :web, :db, :primary => true

set :git_branch, "master"
set :git_server, "peweproxy-staging.fiit.stuba.sk"

def run_migrations
#  run "cd #{current_path}/schema/ && rake migrate RAILS_ENV='staging'"
end

def prepare_configuration
  run "mv #{current_path}/conf/rabbit.conf.staging #{current_path}/conf/rabbit.conf"
  run "mv #{current_path}/conf/log4j.xml.staging #{current_path}/conf/log4j.xml"
  run "mv #{current_path}/proxy.jar  #{current_path}/proxy-staging.jar"
  run "mv #{current_path}/plugins/MySQLDatabaseConnectionProviderService.xml.staging  #{current_path}/plugins/MySQLDatabaseConnectionProviderService.xml"
end

def restart_proxy
  run "sudo god restart proxy"
end
