require File.join(File.dirname(__FILE__), 'test_helper')

class ConsoleUpdate::NamedScopeTest < Test::Unit::TestCase
  test "chained console_update calls actual named_scope" do
    big_bird = Bird.create({:name=>"big bird"})
    Bird.stub!(:system) { |editor, file|
      YAML::load_file(file)[0].keys.sort.should == Bird.default_editable_attributes.sort
    }
    ConsoleUpdate.enable_named_scope
    Bird.just_big_bird.console_update
  end
end