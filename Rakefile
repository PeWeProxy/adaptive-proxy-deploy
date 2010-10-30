require 'pathname'
APP_ROOT = File.dirname(Pathname.new(__FILE__).realpath)
$:.unshift(File.join(APP_ROOT, "lib"))

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'fileutils'
require 'jake'

CHECKOUT_DIR = 'checkouts/'
PROXY_DIR = CHECKOUT_DIR + 'adaptive-proxy'
PLUGINS_DIR = CHECKOUT_DIR + 'adaptive-proxy-plugins'
JKEY_DIR = CHECKOUT_DIR + 'jkey-extractor'
BROWSER_PATCHER_DIR = CHECKOUT_DIR + 'adaptive-proxy-browser-patcher'
FFEXTENSION_DIR= CHECKOUT_DIR + 'adaptive-proxy-ffextension'
PROXY_WEB_DIR = CHECKOUT_DIR + 'adaptive-proxy-web'
RELEASE_DIR = '.'


# {{{ git 
namespace :git do
  desc "Find and run 'git pull' on all git repositories"
  task :pull do
    Dir.glob('*').each do |f|
      if File.directory? f and File.exist? "#{f}/.git" then
        original_path = Dir.getwd
        Dir.chdir f
        `git pull`
        Dir.chdir original_path
      end
    end
  end

  desc "Clones jkey-extractor, adaptive-proxy and adaptive-proxy-plugins repositories"
  task :clone do
    %w(adaptive-proxy adaptive-proxy-plugins jkey-extractor).each { |repository| sh "git clone ssh://gitosis@relax.fiit.stuba.sk/#{repository}.git #{CHECKOUT_DIR}#{repository}" }

    branch = ENV['branch']
    puts "Using plugin branch: #{branch}"

    sh "cd #{CHECKOUT_DIR}/adaptive-proxy-plugins && git pull origin #{branch} && cd -"
  end
end

# }}}



#{{{ release
namespace :release do
  TEMP_DIR='tmp/'

  desc "Move proxy.jar and its dependencies to RELEASE_DIR"
  task :move do
    all_files = Dir.glob('*')

    FileUtils.mkdir(TEMP_DIR)
    FileUtils.mv(all_files, TEMP_DIR)

    Dir.chdir(TEMP_DIR) do
      %w(proxy.jar libs conf plugins htdocs).each do |file|
        FileUtils.cp_r("#{PROXY_DIR}/#{file}", "../#{RELEASE_DIR}")
      end
    end
    FileUtils.cp_r(Dir.glob("#{TEMP_DIR}/#{PLUGINS_DIR}/plugins/*"), "#{RELEASE_DIR}/plugins/")

    FileUtils.mkdir("#{RELEASE_DIR}/logs")
  end

  desc "Delete checkouts"
  task :cleanup do
    FileUtils.rm_r(TEMP_DIR)
  end

  desc "Build proxy, plugins and all of their dependencies, bundle into proxy.jar"
  task :build => ["jkeyextractor:build", "jkeyextractor:jar", "proxy:build", "plugins:build", "plugins:jar", "proxy:manifest", "proxy:jar"]

  desc "Prepare proxy release"
  task :prepare => ["git:clone", "release:build", "release:move", "release:filters", "release:cleanup"]

  desc "Rebuild and setup filters"
  task :filters do
    Dir.chdir("#{TEMP_DIR}/filter") do
      sh 'bin/update_filters'
    end
    FileUtils.mv("#{TEMP_DIR}/filter/filter.txt", "#{RELEASE_DIR}")
  end
end
#}}}

task :default => "release:prepare"
