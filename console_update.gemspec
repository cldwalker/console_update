# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{console_update}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = %q{2009-10-22}
  s.description = %q{Updates records from the console via your preferred editor. You can update a record's columns as well as any attribute that has accessor methods. Records are edited via a temporary file and once saved, the records are updated. Records go through a filter before and after editing the file. Yaml is the default filter, but you can define your own filters.}
  s.email = %q{gabriel.horner@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "init.rb",
    "lib/console_update.rb",
    "lib/console_update/filter.rb",
    "lib/console_update/filter/yaml.rb",
    "lib/console_update/named_scope.rb",
    "rails/init.rb",
    "test/console_update_test.rb",
    "test/filter_test.rb",
    "test/named_scope_test.rb",
    "test/schema.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://tagaholic.me/console_update/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tagaholic}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A rails plugin which allows you to edit your database records via the console and your favorite editor.}
  s.test_files = [
    "test/console_update_test.rb",
    "test/filter_test.rb",
    "test/named_scope_test.rb",
    "test/schema.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
