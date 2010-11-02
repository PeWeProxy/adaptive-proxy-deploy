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
    #build and bundle jkey-extractor
    Dir.chdir(JKEY_DIR) do
      sh "rake build"
      sh "rake jar"
    end
    FileUtils.cp("#{JKEY_DIR}/jkeyextractor.jar", "#{CORE_PLUGINS_DIR}/external_libs")
    FileUtils.cp_r(Dir.glob("#{JKEY_DIR}/lib/*"), "#{PROXY_DIR}/libs")

    #build proxy
    Dir.chdir(PROXY_DIR) do
      puts "building adaptive proxy..."
      #sh "rake build"
    end

    #build and bundle all plugin bundles
    Dir.glob("#{PLUGINS_DIR}/*") do |plugin_dir|
      
      plugin_name = plugin_dir.match(/[^\/]+$/)[0]

      Dir.chdir(plugin_dir) do
        sh "rake build"
        sh "rake jar"
      end
      FileUtils.cp("#{PLUGINS_DIR}/#{plugin_name}/#{plugin_name}.jar", "#{PROXY_DIR}/libs")
      FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/external_libs/*"), "#{PROXY_DIR}/libs")

    end

    #bundle proxy
    Dir.chdir(PROXY_DIR) do
      sh "rake manifest"
      sh "rake jar"
    end
  end
  
end