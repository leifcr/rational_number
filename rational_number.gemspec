# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rational_number/version"

Gem::Specification.new do |s|
  s.name = "rational_number"
  s.version = RationalNumber::VERSION

  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Leif Ringstad"]
  s.date = "2013-08-21"
  s.summary = "Rational Numbers for trees"
  s.description = "Provide basic rational numbers for trees"
  s.email = "leifcr@gmail.com"
  s.extra_rdoc_files = [ "README.md" ]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.homepage = "https://github.com/leifcr/rational_number"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("simplecov-gem-adapter")

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.3.0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.3.0"])
  end
end

