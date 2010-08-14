require 'mocha'
require 'mocha-on-bacon'
require 'bacon'
require 'activerecord'
require 'console_update'
require File.join(File.dirname(__FILE__), '..', 'init')

#Setup logger
require 'logger'
# ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "test.log"))
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

#Setup db
ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

#Define schema
require File.join(File.dirname(__FILE__), 'schema')
class ::Bird < ActiveRecord::Base
  named_scope :just_big_bird, :conditions=>{:name=>'big bird'}
  attr_protected :description
  attr_accessor :tag_list
  can_console_update
end

class Bacon::Context
  def before_all; yield; end

  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end
end
