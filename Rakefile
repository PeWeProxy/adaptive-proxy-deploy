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
      
      #copy static content
      FileUtils.mkdir "#{PROXY_DIR}/htdocs" unless File.exists?("#{PROXY_DIR}/htdocs")
      FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/static/*"), "#{PROXY_DIR}/htdocs")
      
      #copy and update configuration xml files
	  FileUtils.mkdir "#{PROXY_DIR}/plugins" unless File.exists?("#{PROXY_DIR}/plugins")
		
	  contains = Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/plugins/*.xml")
	  contains.each do |configFile|
	  	configFileName = configFile.split('/').last
		   
		file = File.new(configFile)
		doc = REXML::Document.new file
			
		doc.elements.each("plugin/libraries/lib") do |element|
			element.text = "#{plugin_name}#{element.text}"
		end
			
		doc.elements['plugin/classLocation'].text = "#{plugin_name}.jar"
			
		formatter = REXML::Formatters::Default.new
		File.open("#{PROXY_DIR}/plugins", 'w') do |result|
			formatter.write(doc, result)
		end
  	  end
  	  
      
    end
  end

end