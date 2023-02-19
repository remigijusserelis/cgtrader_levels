# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cgtrader_levels/version'

Gem::Specification.new do |spec|
  spec.name          = 'cgtrader_levels'
  spec.version       = CgtraderLevels::VERSION
  spec.authors       = ['Remigijus Serelis']
  spec.email         = ['r.serelis@gmail.com@gmail.com']
  spec.summary       = 'Homework assigment for CGTrader.'
  spec.description   = 'Implementation of user leveling system that rewards them with various bonuses.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '3.2.0'

  spec.add_dependency 'activerecord'
  spec.add_dependency 'sqlite3'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
end
