set :deploy_to, "/home/peweproxy/release"
set :repository,  "git://gitbus.fiit.stuba.sk/pewe-proxy-team-project/adaptive-proxy-deploy.git"
#stage-specific, moved to config/deploy/staging and config/deploy/production.rb
#set :deploy_to, "/var/rails/#{application}"
server "peweproxy.fiit.stuba.sk", :app, :web, :db, :primary => true

set :git_branch, "master"
set :git_server, "peweproxy-staging.fiit.stuba.sk"

def run_migrations
  run "cd #{current_path}/schema/ && rake migrate RAILS_ENV='production'"
end

def restart_proxy
  run "god restart proxy"
end

