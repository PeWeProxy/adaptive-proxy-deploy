require 'capistrano/ext/multistage'
set :application, "peweproxy-release"
set :scm, :git
set :keep_releases, 2 
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "peweproxy"
set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task "start", :roles => :app do
#    passenger.restart
  end

task "restart", :roles => :app do
#    passenger.restart
  end
end

#task :after_update_code do
task :proxy_build do
   stream "cd #{current_path} && rake --rakefile=#{current_path}/Rakefile release:erase_crontab"
   stream "cd #{current_path} && rake --rakefile=#{current_path}/Rakefile release:pull branch=#{git_branch} git_server=#{git_server} stage=#{stage}"
	 stream "cd #{current_path} && rake --rakefile=#{current_path}/Rakefile release:build branch=#{git_branch} git_server=#{git_server} stage=#{stage}"
	 stream "cd #{current_path} && rake --rakefile=#{current_path}/Rakefile release:after PROXY_ROOT=#{current_path}/deploy"
	 stream "cd #{current_path} && rake --rakefile=#{current_path}/Rakefile release:move"
   restart_proxy
end

after 'deploy', 'proxy_build', 'deploy:cleanup'
deploy.task :finalize_update, :except => { :no_release => true } do
#NOOP
end
