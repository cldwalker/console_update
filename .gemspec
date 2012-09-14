# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/console_update/version"

Gem::Specification.new do |s|
  s.name        = "console_update"
  s.version     = ConsoleUpdate::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://tagaholic.me/console_update/"
  s.summary = "Edit your database records via the console and your favorite editor."
  s.description = "Updates records from the console via your preferred editor. You can update a record's columns as well as <i>any attribute</i> that has accessor methods.  Records are edited via a temporary file and once saved, the records are updated. Records go through a filter before and after editing the file. Yaml is the default filter, but you can define your own filter simply with a module and 2 expected methods. See ConsoleUpdate::Filter for more details. Compatible with all major Ruby versions and Rails 2.3.x and up."
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency 'bacon', '>= 1.1.0'
  s.add_development_dependency 'mocha', '~> 0.12.1'
  s.add_development_dependency 'mocha-on-bacon', '~> 0.2.1'
  s.add_development_dependency 'bacon-bits'
  s.add_development_dependency 'activerecord', '~> 2.3.0'
  s.add_development_dependency 'sqlite3', '~> 1.3.0'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec .travis.yml}
  s.files += ['init.rb', '.gitignore', 'Gemfile']
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
