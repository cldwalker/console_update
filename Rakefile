require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts = ["-T -x '/Library/Ruby/*'"]
    t.verbose = true
  end
rescue LoadError
  puts "Rcov not available. Install it for rcov-related tasks with: sudo gem install rcov"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "console_update"
    s.summary = "A rails plugin which allows you to edit your database records via the console and your favorite editor."
    s.description = "Updates records from the console via your preferred editor. You can update a record's columns as well as any attribute that has accessor methods. Records are edited via a temporary file and once saved, the records are updated. Records go through a filter before and after editing the file. Yaml is the default filter, but you can define your own filters."
    s.email = "gabriel.horner@gmail.com"
    s.homepage = "http://tagaholic.me/console_update/"
    s.authors = ["Gabriel Horner"]
    s.rubyforge_project = 'tagaholic'
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
    s.files = FileList["CHANGELOG.rdoc", "Rakefile", "VERSION.yml", "README.rdoc", "init.rb", "LICENSE.txt", "{rails,lib,test}/**/*"]
  end

rescue LoadError
  puts "Jeweler not available. Install it for jeweler-related tasks with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'test'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
