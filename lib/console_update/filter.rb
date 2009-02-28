require 'console_update/filter/yaml'

module ConsoleUpdate
  # A filter converts database records to a string and vice versa.
  # A database record is represented as a hash of attributes with stringified keys.
  # Each hash should have an id attribute to map it to its database record.
  # To create your own filter, create a module in the ConsoleUpdate::Filter namespace.
  # Although the name of the module can be anything, if only the first letter is capitalized
  # then a simple lowercase name of the filter can be used with ConsoleUpdate.filter(). For example
  # :yaml instead of Yaml.
  #
  # A filter should have two methods defined, string_to_hashes() and hashes_to_string().
  # For a good example of a filter see ConsoleUpdate::Filter::Yaml.
  #
  class Filter
    class AbstractMethodError < StandardError; end
    class FilterNotFoundError < StandardError; end
    
    # Creates a filter given a type.
    def initialize(filter_type)
      @filter_type = filter_type
      begin
        filter_module = self.class.const_get(filter_type.to_s.gsub(/^([a-z])/) {|e| $1.upcase })
        self.extend(filter_module)
      rescue NameError
        raise FilterNotFoundError
      end
    end
    
    # Takes an an array of hashes representing database records and converts them to a string for editing.
    def hashes_to_string(hashes)
      raise AbstractMethodError
    end
    
    # Takes the string from the updated file and converts back to an array of hashes.
    def string_to_hashes(string)
      raise AbstractMethodError
    end
  end
end