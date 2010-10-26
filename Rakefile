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

# {{{ jake gem
spec = Gem::Specification.new do |s|
  s.name = %q{jake}
  s.version = "0.1.0"

  s.authors = ["Tomas Kramar"]
  s.description = %q{Build java code with ease.}
  s.email = %q{kramar@fiit.stuba.sk}
  s.files = Dir.glob('lib/**/*.rb') + %w{Rakefile}
  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Build java code with ease}
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
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
