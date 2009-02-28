module ConsoleUpdate
  
  # Adds a global scoped method, console_update(), which can be chained
  # to the end of any named scopes.
  # For example, if Url has a named scope :tagged_with:
  #   Url.tagged_with('physics').console_update
  def self.enable_named_scope  
    ActiveRecord::NamedScope::Scope.send :include, NamedScope
  end
  
  module NamedScope #:nodoc:
    def console_update(options={})
      records = send(:proxy_found)
      unless records.empty?
        records[0].class.console_update(records, options)
      else
        []
      end
    end
  end
end