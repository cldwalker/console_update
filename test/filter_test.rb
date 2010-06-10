require File.join(File.dirname(__FILE__), 'test_helper')

#test filter
module ConsoleUpdate
  class Filter
    module Test
    end
  end
end

# class ConsoleUpdate::FilterTest < Test::Unit::TestCase
describe "Filter" do
  it "incorrect filter name raises FilterNotFoundError" do
    should.raise(ConsoleUpdate::Filter::FilterNotFoundError) {
      ConsoleUpdate::Filter.new(:blah)
    }
  end
  
  it "filter without proper methods raises AbstractMethodError" do
    should.raise(ConsoleUpdate::Filter::AbstractMethodError) {
      ConsoleUpdate::Filter.new(:test).string_to_hashes('blah')
    }    
  end

  it "extends filter for a non-lowercase filter name correctly" do
    filter_meta_class = ConsoleUpdate::Filter.new("Test").instance_eval("class<<self; self;end")
    filter_meta_class.ancestors.include?(ConsoleUpdate::Filter::Test).should == true
  end
end
