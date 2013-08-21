# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bundler/setup'
require "bundler/gem_tasks"
require 'rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/*_spec.rb'
    spec.rspec_opts = ['--color']
  end
  task :default => :spec
rescue LoadError
  nil
end

# # Ignore LoadError for jeweler when running on e.g. Travis-CI
# begin
#   require 'jeweler'
#   Jeweler::Tasks.new do |gem|
#     # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
#     gem.name        = "rational_number"
#     gem.homepage    = "https://github.com/leifcr/rational_number"
#     gem.license     = "MIT"
#     gem.summary     = %Q{Rational Number basic class for Ruby}
#     gem.description = %Q{Provide basic rational numbers for ruby}
#     gem.email       = "leifcr@gmail.com"
#     gem.authors     = ["Leif Ringstad"]
#     gem.files.exclude [".ruby-*", ".travis.yml"]
#     # dependencies defined in Gemfile
#   end
#   Jeweler::RubygemsDotOrgTasks.new
# rescue LoadError
#   nil
# end
