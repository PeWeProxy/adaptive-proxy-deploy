require 'rubygems'
require 'fileutils'
require 'jake'


CHECKOUT_DIR = ''


namespace :release do

  JKEY_DIR = CHECKOUT_DIR + "jkey-extractor"
  PROXY_DIR = CHECKOUT_DIR + "adaptive-proxy"
  PLUGINS_DIR = CHECKOUT_DIR + "adaptive-proxy-plugins"
  CORE_PLUGINS_DIR = CHECKOUT_DIR + "plugins/adaptive-proxy-coreplugins"

  desc "Find and run 'git pull' on all git submodules"
  task :pull do
	 branch = 'master'
	`git submodule init`
	`git submodule update`
    Dir.glob('*').each do |f|
      if File.directory? f and File.exist? "#{f}/.git" then
        original_path = Dir.getwd
        Dir.chdir f
		`git pull origin #{branch}`
        Dir.chdir original_path
      end
    end
    Dir.glob('plugins/*').each do |f|
      if File.directory? f and File.exist? "#{f}/.git" then
        original_path = Dir.getwd
        Dir.chdir f
		`git pull origin #{branch}`
        Dir.chdir original_path
      end
    end
  end

#  desc "Clones jkey-extractor, adaptive-proxy and adaptive-proxy-plugins repositories"
#  task :clone do
#    %w(adaptive-proxy adaptive-proxy-plugins jkey-extractor).each { |repository| sh "git clone ssh://gitosis@#{ENV['git_server']}/#{repository}.git #{CHECKOUT_DIR}#{repository}" }

#    branch = ENV['branch']
#    puts "Using plugin branch: #{branch}"

#    sh "cd #{CHECKOUT_DIR}/adaptive-proxy-plugins && git pull origin #{branch} && cd -"
#  end
  
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

    #loop in all plugin modulesplugin_dir
    Dir.glob("#{PLUGINS_DIR}/*") do |plugin_dir|
      #magic
      plugin_name = plugin_dir.match(/[^\/]+$/)[0]

      FileUtils.mkdir "#{PROXY_DIR}/offline" unless File.exists?("#{PROXY_DIR}/offline")

      #rake
      Dir.chdir(plugin_dir) do
        sh "rake"
        FileUtils.cp_r(Dir.glob("offline/build/*"), "#{PROXY_DIR}/offline")
      end

      #copy libs
	  FileUtils.mkdir "#{PROXY_DIR}/libs" unless File.exists?("#{PROXY_DIR}/libs")
      FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/external_libs/*"), "#{PROXY_DIR}/libs")
      
      #copy static contentplugin_dir
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
	
	#copy all to main release direcotry
	FileUtils.mkdir "htdocs" unless File.exists?("htdocs")
	FileUtils.mkdir "libs" unless File.exists?("libs")
    FileUtils.mkdir "offline" unless File.exists?("offline")
	FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/static/*"), "htdocs")
	FileUtils.cp_r(Dir.glob("#{PLUGINS_DIR}/#{plugin_name}/external_libs/*"), "libs")
	FileUtils.cp(Dir.glob("#{PROXY_DIR}/proxy.jar"), ".")
	FileUtils.cp_r(Dir.glob("offline/build/*"), "offline")


  end

end

task :default => ["release:pull", "release:build"]
