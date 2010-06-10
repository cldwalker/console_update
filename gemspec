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
  s.description = "Updates records from the console via your preferred editor. You can update a record's columns as well as any attribute that has accessor methods. Records are edited via a temporary file and once saved, the records are updated. Records go through a filter before and after editing the file. Yaml is the default filter, but you can define your own filters."
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'tagaholic'
  s.add_development_dependency 'bacon'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'mocha-on-bacon'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c}]) + %w{Rakefile gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
end