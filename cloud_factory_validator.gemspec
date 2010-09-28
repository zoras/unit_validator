# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cloud_factory_validator}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["millisami", "saroz"]
  s.date = %q{2010-09-29}
  s.description = %q{Takes the Instruction Input as Rule, parse the CSV files and applies the validation and returns valid and invalid units}
  s.email = %q{saroj@sproutfiy.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".autotest",
    ".gitignore",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "autotest/discover.rb",
    "fixtures/gdoc.csv",
    "fixtures/gdoc.ods",
    "fixtures/gdoc.xls",
    "fixtures/gdoc.xlsx",
    "lib/cloud_factory_validator.rb",
    "lib/generic_spreadsheet.rb",
    "spec/.rspec",
    "spec/cloud_factory_validator_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/sprout/cloud_factory_validator}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Takes the Instruction Input as Rule, parse the CSV files and does the validation}
  s.test_files = [
    "spec/cloud_factory_validator_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<roo>, [">= 0"])
      s.add_development_dependency(%q<zip>, [">= 0"])
      s.add_development_dependency(%q<spreadsheet>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<google-spreadsheet-ruby>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<autotest-fsevent>, [">= 0.2.2"])
      s.add_development_dependency(%q<autotest-growl>, [">= 0.2.4"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<roo>, [">= 0"])
      s.add_dependency(%q<zip>, [">= 0"])
      s.add_dependency(%q<spreadsheet>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<autotest-fsevent>, [">= 0.2.2"])
      s.add_dependency(%q<autotest-growl>, [">= 0.2.4"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<roo>, [">= 0"])
    s.add_dependency(%q<zip>, [">= 0"])
    s.add_dependency(%q<spreadsheet>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<autotest-fsevent>, [">= 0.2.2"])
    s.add_dependency(%q<autotest-growl>, [">= 0.2.4"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta.19"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre3"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

