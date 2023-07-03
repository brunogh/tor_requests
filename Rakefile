# frozen_string_literal: true

require "rubygems"
require "bundler"
require "rake"
require "jeweler"
require "rspec/core"
require "rspec/core/rake_task"
require "rdoc/task"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tor_requests"
  gem.homepage = "http://github.com/brunogh/tor_requests"
  gem.license = "MIT"
  gem.summary = "Create anonymously requests through Tor network"
  gem.description = "Create anonymously requests through Tor network"
  gem.email = "brunogh@gmail.com"
  gem.authors = ["Bruno Ghisi"]
  # dependencies defined in Gemfile
  gem.add_dependency "socksify"
end

Jeweler::RubygemsDotOrgTasks.new

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList["spec/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
  spec.rcov = true
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?("VERSION") ? File.read("VERSION") : ""

  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "tor_requests #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

task default: :spec
