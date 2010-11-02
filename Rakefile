require 'rubygems'
require 'fileutils'
require 'jake'

namespace :release do

  JKEY_DIR = "jkey-extractor"
  PROXY_DIR = "adaptive-proxy"
  PLUGINS_DIR = "adaptive-proxy-plugins"
  CORE_PLUGINS_DIR = PLUGINS_DIR + "/adaptive-proxy-core"

  desc "Build proxy, plugins and all of their dependencies, bundle into proxy.jar"

  task :build do
    #build and bundle jkey-extractor, copy libs
    Dir.chdir(JKEY_DIR) do
      sh "rake"
    end
    FileUtils.cp("#{JKEY_DIR}/jkeyextractor.jar", "#{CORE_PLUGINS_DIR}/external_libs")
    FileUtils.cp_r(Dir.glob("#{JKEY_DIR}/lib/*"), "#{PROXY_DIR}/libs")

    #build and bundle proxy
    Dir.chdir(PROXY_DIR) do
      sh "rake" #Warning! This won't work under Windows. The command line is too long.
    end

    #loop in all plugin modules
    Dir.glob("#{PLUGINS_DIR}/*") do |plugin_dir|
      #magic
      plugin_name = plugin_dir.match(/[^\/]+$/)[0]

      #rake
      Dir.chdir(plugin_dir) do
        sh "rake"
      end

      #copy libs
      FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/external_libs/*"), "#{PROXY_DIR}/libs")
    end
  end

end