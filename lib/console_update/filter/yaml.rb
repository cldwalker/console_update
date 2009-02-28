require 'yaml'

module ConsoleUpdate
  class Filter    
    module Yaml
      def string_to_hashes(string)
        YAML::load(string)
      end
    
      def hashes_to_string(hashes)
        hashes.to_yaml
      end
    end
  end
end
  