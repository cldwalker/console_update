current_dir = File.dirname(__FILE__)
$:.unshift(current_dir) unless $:.include?(current_dir) || $:.include?(File.expand_path(current_dir))
require 'tempfile'
require 'console_update/named_scope'
require 'console_update/filter'

module ConsoleUpdate
  class <<self; attr_accessor(:filter, :editor); end
  def self.included(base) #:nodoc:
    @filter = :yaml
    @editor = ENV["EDITOR"]
    base.extend ClassMethods
  end
  
  module ClassMethods
    # Enable a model to be updated via the console and an editor. By default editable
    # attributes are columns with text, boolean or integer-like values.
    # ==== Options:
    # [:only] Sets these attributes as the default editable attributes.
    # [:except] Sets the default editable attributes as normal except for these attributes.
    # [:editor] Overrides global editor for just this model.
    def can_console_update(options={})
      cattr_accessor :console_editor
      self.console_editor = options[:editor] || ConsoleUpdate.editor
      
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
      [:datetime, :timestamp, :binary, :time, :timestamp]
    end
    
    def get_default_editable_attributes
      self.columns.select {|e| !default_types_to_exclude.include?(e.type) }.map(&:name)
    end
  end
  
  module SingletonMethods
    # This is the main method for updating records.
    # All other update-like methods pass their options through here.
    # ==== Options:
    # [:only] Only edit these attributes.
    # [:except] Edit default attributes except for these.
    # Examples:
    #   records = Url.all :limit=>10
    #   Url.console_update records
    #   Url.console_update records, :only=>%w{column1}
    #   Url.console_update records, :except=>%w{column1}
    def console_update(records, options={})
      begin
        editable_attributes_array = records.map {|e| e.console_editable_attributes(options) }
        editable_string = filter.hashes_to_string(editable_attributes_array)
        new_attributes_array = editor_update(editable_string)
        records.each do |record|
          if (record_attributes = new_attributes_array.detect {|e| e['id'] == record.id })
            record.update_console_attributes(record_attributes)
          end
        end
      rescue ConsoleUpdate::Filter::AbstractMethodError
        puts "Undefined filter method for #{ConsoleUpdate::filter} filter"
      rescue Test::Unit::AssertionFailedError=>e
        raise e
      rescue Exception=>e
        puts "Some record(s) didn't update because of this error: #{e}"
      ensure
        #this attribute should only last duration of method
        reset_editable_attribute_names
      end
    end
    
    def filter #:nodoc:
      @filter ||= ConsoleUpdate::Filter.new(ConsoleUpdate.filter)
    end
    
    # Console updates a record given an id.
    def find_and_console_update(id, options={})
      console_update([find(id)], options)
    end
    
    # :stopdoc:
    def editor_update(string) 
      tmpfile = Tempfile.new('console_update')
      File.open(tmpfile.path, 'w+') {|f| f.write(string)}
      system(console_editor, tmpfile.path)
      updated_string = File.read(tmpfile.path)
      filter.string_to_hashes(updated_string)
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
    # :startdoc:
  end
  
  module InstanceMethods
    # Console updates the object.
    def console_update(options={}) 
      self.class.console_update([self], options)
    end
    
    # :stopdoc:
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
    #:startdoc:
  end  
end