require 'rubygems'
require 'fileutils'
require 'jake'



namespace :release do

  JKEY_DIR = CHECKOUT_DIR + "jkey-extractor"
  PROXY_DIR = CHECKOUT_DIR + "adaptive-proxy"
  PLUGINS_DIR = CHECKOUT_DIR + "plugins"
  CORE_PLUGINS_DIR = CHECKOUT_DIR + "adaptive-proxy-coreplugins"
  DEPLOY_TEMP_DIR = 'deploy/'

  desc "Find and run 'git pull' on all git submodules"
  task pull do
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
  #create deploy directory structure
	FileUtils.mkdir "#{DEPLOY_TEMP_DIR}" unless File.exists?("#{DEPLOY_TEMP_DIR}")
	FileUtils.mkdir "#{DEPLOY_TEMP_DIR}offline" unless File.exists?("#{DEPLOY_TEMP_DIR}offline")
	FileUtils.mkdir "#{DEPLOY_TEMP_DIR}libs" unless File.exists?("#{DEPLOY_TEMP_DIR}libs")
	FileUtils.mkdir "#{DEPLOY_TEMP_DIR}htdocs" unless File.exists?("#{DEPLOY_TEMP_DIR}htdocs")
	FileUtils.mkdir "#{DEPLOY_TEMP_DIR}plugins" unless File.exists?("#{DEPLOY_TEMP_DIR}plugins")
  
    #build and bundle jkey-extractor, copy libs
    Dir.chdir(JKEY_DIR) do
      sh "rake"
    end
    FileUtils.cp("#{JKEY_DIR}/jkeyextractor.jar", "#{CORE_PLUGINS_DIR}/external_libs")
    FileUtils.cp_r(Dir.glob("#{JKEY_DIR}/lib/*"), "#{DEPLOY_TEMP_DIR}libs")

    #build and bundle proxy
    Dir.chdir(PROXY_DIR) do
      sh "rake" #Warning! This won't work under Windows. The command line is too long.
    end



    #loop in all plugin modulesplugin_dir
    Dir.glob("#{PLUGINS_DIR}/*") do |plugin_dir|
      #magic
      plugin_name = plugin_dir.match(/[^\/]+$/)[0]


      #rake
		sh "#{plugin_dir}/rake"
		
		FileUtils.cp_r(Dir.glob("#{plugin_dir}/offline/build/*"), "#{DEPLOY_TEMP_DIR}offline")

      #copy libs
      FileUtils.cp_r(Dir.glob("#{plugin_dir}/external_libs/*"), "#{DEPLOY_TEMP_DIR}libs")
      
      #copy static contentplugin_dir
      FileUtils.cp_r(Dir.glob("#{plugin_dir}/static/*"), "#{DEPLOY_TEMP_DIR}htdocs")
      
      #copy and update configuration xml files
            contains = Dir.glob("#{plugin_dir}/plugins/*")
            contains.each do |configFile|
                ext = File.extname(configFile)
                if ext == ".xml"
                    configFileName = configFile.split('/').last

                    file = File.new(configFile)
                    doc = REXML:ocument.new file

                    doc.elements.each("plugin/libraries/lib") do |element|
                        element.text = "#{plugin_name}#{element.text}"
                    end

                    doc.elements.each('plugin/classLocation') do |element|
                        element.text = "#{plugin_name}.jar"
                    end

                    formatter = REXML::Formatters:efault.new
                    File.open("#{DEPLOY_TEMP_DIR}plugins/#{configFileName}", 'w') do |result|
                        formatter.write(doc, result)
                    end
                else
                    FileUtils.cp_r(Dir.glob("#{configFile}"), "#{DEPLOY_TEMP_DIR}plugins")
                end
        end
        
      
    end
    
  end

end

task efault => ["releaseull", "release:build"]