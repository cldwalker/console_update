require 'console_update/filter/yaml'

module ConsoleUpdate
  class Filter
    class AbstractMethodError < StandardError; end
    class FilterNotFoundError < StandardError; end
    
    def initialize(filter_type)
      @filter_type = filter_type
      begin
        filter_module = self.class.const_get(filter_type.to_s.capitalize)
        self.extend(filter_module)
      rescue NameError
        raise FilterNotFoundError
      end
    end
    
    def string_to_hashes(string)
      raise AbstractMethodError
    end
  
    def hashes_to_string(hashes)
      raise AbstractMethodError
    end
  end
end