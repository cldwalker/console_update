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
end
