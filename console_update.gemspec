# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{console_update}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = %q{2009-02-28}
  s.description = %q{A rails plugin which allows you to edit your database records via the console and your favorite editor.}
  s.email = %q{gabriel.horner@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.files = ["Rakefile", "VERSION.yml", "README.rdoc", "init.rb", "LICENSE.txt", "rails/init.rb", "lib/console_update", "lib/console_update/filter", "lib/console_update/filter/yaml.rb", "lib/console_update/filter.rb", "lib/console_update/named_scope.rb", "lib/console_update.rb", "test/console_update_test.rb", "test/filter_test.rb", "test/named_scope_test.rb", "test/schema.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cldwalker/console_update}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A rails plugin which allows you to edit your database records via the console and your favorite editor.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
