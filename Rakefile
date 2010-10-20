require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "unit_validator"
  gem.summary = %Q{Takes the Instruction Input as Rule, parse the CSV files and does the validation}
  gem.description = %Q{Takes the Instruction Input as Rule, parse the CSV files and applies the validation and returns valid and invalid units}
  gem.email = "saroj@sprout-technology.com"
  gem.homepage = "http://github.com/zoras/CFInputValidator"
  gem.authors = ["millisami", "zoras"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'roo'
  gem.add_runtime_dependency 'zip'
  gem.add_runtime_dependency 'spreadsheet'
  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'google-spreadsheet-ruby'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'builder'

  gem.add_development_dependency "rspec", ">= 2.0.0.rc"
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.5.0.pre3"
  gem.add_development_dependency "rcov", ">= 0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
# custom rcov
require File.expand_path(File.dirname(__FILE__) + '/lib/tasks/rcov_custom')
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "unit_validator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
