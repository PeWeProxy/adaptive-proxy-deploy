require 'rubygems'
require 'fileutils'
require 'jake'
require 'rexml/document'


namespace :release do

	JKEY_DIR =  "jkey-extractor"
  PROXY_DIR = "adaptive-proxy"
  PLUGINS_DIR = "plugins"
  DEPLOY_TEMP_DIR = 'deploy/'
	CORE_PLUGINS_DIR = "adaptive-proxy-coreplugins"

  desc "Find and run 'git pull' on all git submodules"
  task :pull do
		branch = 'master'
		`git submodule init`
		`git submodule update`
    Dir.glob('*').each do |f|
      if File.directory? f and File.exist? "#{f}/.git" then
        Dir.chdir f do
					`git pull origin #{branch}`
				end
      end
    end
    Dir.glob('plugins/*').each do |f|
      if File.directory? f and File.exist? "#{f}/.git" then
        Dir.chdir f do
					`git pull origin #{branch}`
				end
      end
    end
  end

  desc "Build proxy, plugins and all of their dependencies, bundle into proxy.jar"
  task :build do
		#create deploy directory structure
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}" unless File.exists?("#{DEPLOY_TEMP_DIR}")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}offline" unless File.exists?("#{DEPLOY_TEMP_DIR}offline")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}offline/scripts" unless File.exists?("#{DEPLOY_TEMP_DIR}offline/scripts")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}libs" unless File.exists?("#{DEPLOY_TEMP_DIR}libs")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}htdocs" unless File.exists?("#{DEPLOY_TEMP_DIR}htdocs")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}htdocs/public" unless File.exists?("#{DEPLOY_TEMP_DIR}htdocs/public")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}plugins" unless File.exists?("#{DEPLOY_TEMP_DIR}plugins")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}plugins/libs" unless File.exists?("#{DEPLOY_TEMP_DIR}plugins/libs")
    FileUtils.mkdir "#{DEPLOY_TEMP_DIR}plugins/services" unless File.exists?("#{DEPLOY_TEMP_DIR}plugins/services")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}conf" unless File.exists?("#{DEPLOY_TEMP_DIR}conf")
		FileUtils.mkdir "#{DEPLOY_TEMP_DIR}logs" unless File.exists?("#{DEPLOY_TEMP_DIR}logs")

		#build and bundle jkey-extractor, copy libs
		#Dir.chdir(JKEY_DIR) do
		#	sh "rake"
		#end
		#FileUtils.cp("#{JKEY_DIR}/jkeyextractor.jar", "#{PLUGINS_DIR}/#{CORE_PLUGINS_DIR}/external_libs")
		#FileUtils.cp_r(Dir.glob("#{JKEY_DIR}/lib/*"), "#{DEPLOY_TEMP_DIR}libs")

    #build and bundle proxy
    Dir.chdir(PROXY_DIR) do
      sh "rake" #Warning! This won't work under Windows. The command line is too long.
    end
		FileUtils.cp("#{PROXY_DIR}/proxy.jar", "#{DEPLOY_TEMP_DIR}")
		FileUtils.cp_r(Dir.glob("#{PROXY_DIR}/libs/*"), "#{DEPLOY_TEMP_DIR}libs")
		FileUtils.cp_r(Dir.glob("#{PROXY_DIR}/conf/*"),"#{DEPLOY_TEMP_DIR}conf")
		FileUtils.cp_r(Dir.glob("#{PROXY_DIR}/htdocs/*"),"#{DEPLOY_TEMP_DIR}htdocs")

    #debugging order
    order = ["adaptive-proxy-coreplugins", "adaptive-proxy-bundle-messageboard", "adaptive-proxy-bundle-search", "adaptive-proxy-bundle-search-goals", "adaptive-proxy-bundle-broken-pages-reporter", "adaptive-proxy-bundle-keywords"]

    #loop in all plugin modules in specified order
    order.each do |plugin_name|
      plugin_dir = PLUGINS_DIR + "/" + plugin_name

      #rake
			Dir.chdir(plugin_dir) do
				sh "rake RAILS_ENV='#{ENV['stage']}' DEPLOY_PATH='#{ENV['PROXY_ROOT']}'"
			end

      FileUtils.cp("#{plugin_dir}/#{plugin_name}.jar", "#{DEPLOY_TEMP_DIR}plugins/libs")
      FileUtils.cp_r(Dir.glob("#{plugin_dir}/def/bin/*"), "#{DEPLOY_TEMP_DIR}plugins/services")
			FileUtils.cp_r(Dir.glob("#{plugin_dir}/offline/build/*"), "#{DEPLOY_TEMP_DIR}offline")
			FileUtils.cp_r(Dir.glob("#{plugin_dir}/offline/scripts/*"), "#{DEPLOY_TEMP_DIR}offline/scripts")

      #copy libs
      FileUtils.cp_r(Dir.glob("#{plugin_dir}/external_libs/*"), "#{DEPLOY_TEMP_DIR}libs")

      #copy static contentplugin_dir
      FileUtils.cp_r(Dir.glob("#{plugin_dir}/static/*"), "#{DEPLOY_TEMP_DIR}htdocs/public")

      #copy and update configuration xml files
			contains = Dir.glob("#{plugin_dir}/plugins/*")
			contains.each do |configFile|
				ext = File.extname(configFile)
				if ext == ".xml"
					configFileName = configFile.split('/').last

					file = File.new(configFile)
					doc = REXML::Document.new file

					doc.elements.each("plugin/libraries/lib") do |element|
						element.text = "../libs/#{element.text}"
					end

					if File.exists?(plugin_dir+'/Bundlefile')
						File.read(plugin_dir+'/Bundlefile').split.each do |dependency|
							lib_element = REXML::Element.new "lib"
							lib_element.text = 'libs/'+dependency+'.jar'
							libraries_element = doc.elements['plugin/libraries']
							if libraries_element == nil
								libraries_element = REXML::Element.new "libraries"
								doc.root.add_element libraries_element
							end
							libraries_element.add_element lib_element
						end
					end

					doc.elements.each('plugin/classLocation') do |element|
						element.text = "libs/#{plugin_name}.jar"
					end

					formatter = REXML::Formatters::Default.new
					File.open("#{DEPLOY_TEMP_DIR}plugins/#{configFileName}", 'w') do |result|
						formatter.write(doc, result)
					end
				else
					FileUtils.cp_r(Dir.glob("#{configFile}"), "#{DEPLOY_TEMP_DIR}plugins")
				end
			end

		end

	end

  task :variables do

    string = <<EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE variables SYSTEM "VariablesConfiguration.dtd">
        <variables>
        </variables>
EOF
    deploy_variables_doc = REXML::Document.new string

    #TODO: needs refactoring
    order = ["adaptive-proxy-coreplugins", "adaptive-proxy-bundle-messageboard", "adaptive-proxy-bundle-search"]

     order.each do |plugin_name|
      plugin_dir = PLUGINS_DIR + "/" + plugin_name

      if File.exists? "#{plugin_dir}/plugins/variables.xml"
        file = File.new(plugin_dir + "/plugins/variables.xml")
        plugin_variables_doc = REXML::Document.new file
      else
        next
      end

      plugin_variables_doc.elements.each("/variables/variable") {|element|
        deploy_variables_doc.root.elements.add(element)
      }
     end

    formatter = REXML::Formatters::Default.new
		File.open("#{DEPLOY_TEMP_DIR}plugins/variables.xml", 'w') do |write_file|
			formatter.write(deploy_variables_doc, write_file)
		end
  end

	task :after do
		Dir.glob("#{PLUGINS_DIR}/*") do |plugin_dir|
			Dir.chdir(plugin_dir) do
				`rake after:deploy PROXY_ROOT='#{ENV['PROXY_ROOT']}'`
			end
		end
	end

	task :move do

		Dir.glob("./*") do |dir|
			if (dir != './deploy')
				FileUtils.rm_rf(dir)
			end
		end
		FileUtils.cp_r(Dir.glob("#{DEPLOY_TEMP_DIR}*"), ".")
		FileUtils.rm_rf(DEPLOY_TEMP_DIR)
	end

	task :erase_crontab do
		sh "crontab -r &" # & - for ignoring crontab absence error
	end

end