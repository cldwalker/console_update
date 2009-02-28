require File.join(File.dirname(__FILE__), 'test_helper')

#test filter
module ConsoleUpdate
  class Filter
    module Test
    end
  end
end

class ConsoleUpdate::FilterTest < Test::Unit::TestCase
  test "incorrect filter name raises FilterNotFoundError" do
    assert_raises(ConsoleUpdate::Filter::FilterNotFoundError) {
      ConsoleUpdate::Filter.new(:blah)
    }
  end
  
  test "filter without proper methods raises AbstractMethodError" do
    assert_raises(ConsoleUpdate::Filter::AbstractMethodError) {
      ConsoleUpdate::Filter.new(:test).string_to_hashes('blah')
    }    
  end

  test "extends filter for a non-lowercase filter name correctly" do
    filter_meta_class = ConsoleUpdate::Filter.new("Test").instance_eval("class<<self; self;end")
    filter_meta_class.ancestors.include?(ConsoleUpdate::Filter::Test).should be(true)
  end
end
