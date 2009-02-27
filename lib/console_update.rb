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
      cattr_accessor :default_editable_columns
      if options[:only]
        self.default_editable_columns = options[:only]
      elsif options[:except]
        self.default_editable_columns = self.column_names.select {|e| !options[:except].include?(e) }
      else
        self.default_editable_columns = get_default_editable_columns 
      end
      
      extend SingletonMethods
      send :include, InstanceMethods
    end
    
    private
    def default_types_to_exclude
      [:datetime, :timestamp, :binary]
    end
    
    def get_default_editable_columns
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
            record.console_update_attributes(record_attributes)
          end
        end
      rescue Exception=>e
        puts "Some record(s) didn't update because of this error: #{e}"
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
  end
  
  module InstanceMethods
    def console_update(options={}) 
      self.class.console_update([self], options)
    end
    
    def console_update_attributes(new_attributes)
      new_attributes.delete_if {|k,v| attributes[k] == v}
      new_attributes.each do |k, v|  
        send("#{k}=", v)  
      end
      save
    end
    
    def console_editable_attributes(options)
      new_hash = attributes.dup
      if options[:only]
        new_hash.delete_if {|k,v| !options[:only].include?(k)}
      elsif options[:except]
        new_hash.delete_if {|k,v| options[:except].include?(k)}
      else
        new_hash.delete_if {|k,v| !default_editable_columns.include?(k)}
      end
      new_hash['id'] ||= self.id
      new_hash
    end
  end
end
