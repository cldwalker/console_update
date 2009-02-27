require 'tempfile'
require 'yaml'

module ConsoleUpdate
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def can_console_update(options={})
      cattr_accessor :console_editor
      self.console_editor = options[:editor] || ENV["EDITOR"]
      cattr_accessor :default_editable_attributes
      if options[:only]
        self.default_editable_attributes = options[:only]
      elsif options[:except]
        self.default_editable_attributes = self.column_names.select {|e| !options[:except].include?(e) }
      else
        self.default_editable_attributes = get_default_editable_attributes 
      end
      
      extend SingletonMethods
      send :include, InstanceMethods
    end
    
    private
    def default_types_to_exclude
      [:datetime, :timestamp, :binary]
    end
    
    def get_default_editable_attributes
      self.columns.select {|e| !default_types_to_exclude.include?(e.type) }.map(&:name)
    end
  end
  
  module SingletonMethods
    def console_update(records, options={})
      begin
        editable_attributes_array = records.map {|e| e.console_editable_attributes(options) }
        new_attributes_array = editor_update(editable_attributes_array.to_yaml)
        records.each do |record|
          if (record_attributes = new_attributes_array.detect {|e| e['id'] == record.id })
            record.update_console_attributes(record_attributes)
          end
        end
      rescue Exception=>e
        raise e if e.is_a?(Test::Unit::AssertionFailedError)
        puts "Some record(s) didn't update because of this error: #{e}"
      ensure
        #this attribute should only last duration of method
        reset_editable_attribute_names
      end
    end
    
    def find_and_console_update(id, options={})
      console_update([find(id)], options)
    end
    
    def editor_update(string)
      tmpfile = Tempfile.new('console_update')
      File.open(tmpfile.path, 'w+') {|f| f.write(string)}
      system(console_editor, tmpfile.path)
      YAML::load_file(tmpfile.path)
    end

    def reset_editable_attribute_names; @editable_attribute_names = nil ; end
    
    def editable_attribute_names(options={})
      unless @editable_attribute_names
        @editable_attribute_names = if options[:only]
          options[:only]
        elsif options[:except]
          default_editable_attributes - options[:except]
        else
          default_editable_attributes
        end
      end
      @editable_attribute_names
    end
  end
  
  module InstanceMethods
    def console_update(options={}) 
      self.class.console_update([self], options)
    end
    
    def update_console_attributes(new_attributes)
      # delete if value is the same or is an attribute that isn't supposed to be edited
      new_attributes.delete_if {|k,v|
        attributes[k] == v || !self.class.editable_attribute_names.include?(k)
      }
      new_attributes.each do |k, v|  
        send("#{k}=", v)  
      end
      save
    end
    
    def get_console_attributes(attribute_names)
      attribute_names.inject({}) {|h,e|
        h[e] = attributes.has_key?(e) ? attributes[e] : send(e)
        h
      }
    end
    
    def console_editable_attributes(options)
      fresh_attributes = get_console_attributes(self.class.editable_attribute_names(options))
      fresh_attributes['id'] ||= self.id
      fresh_attributes
    end
  end
end
