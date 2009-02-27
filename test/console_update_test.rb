require File.join(File.dirname(__FILE__), 'test_helper')

class ConsoleUpdateTest < Test::Unit::TestCase
  def stub_editor_update_with_records(new_records, options={})
    Bird.stub!(:system) { |editor, file|
      if options[:expected_attributes]
        YAML::load_file(file)[0].keys.sort.should == options[:expected_attributes]
      end
      File.open(file, 'w+') {|f| f.write(new_records.to_yaml)}
    }
  end
  
  def create_big_bird(attributes={})
    @big_bird = Bird.create({:name=>"big bird"}.update(attributes))
  end
  
  context "can_console_update" do
    test "sets default_editable_attributes" do
      Bird.column_names.include?('bin').should be(true)
      Bird.default_editable_attributes.empty?.should be(false)
      Bird.default_editable_attributes.include?('bin').should be(false)
    end
        
    test "sets default_editable_attributes with only option" do
      Bird.can_console_update :only=>['description']
      Bird.default_editable_attributes.should == ['description']
    end
    
    test "sets default_editable_attributes with except option" do
      Bird.can_console_update :except=>['description']
      Bird.default_editable_attributes.sort.should == ["bin", "created_at", "id", "name", "nickname", "updated_at"]
    end
    
    test "sets console_editor with editor option" do
      Bird.can_console_update :editor=>'vi'
      Bird.console_editor.should == 'vi'
    end
  end
  
  context "console_update" do
    before(:all) {|e| Bird.can_console_update }
    before(:each) {|e| Bird.delete_all }
    
    test "updates multiple records" do
      create_big_bird
      @dodo = Bird.create(:name=>"dodo")
      new_records = [@big_bird.attributes.update('name'=>'big birded'), @dodo.attributes.update('name'=>'dudu')]
      stub_editor_update_with_records(new_records)
      Bird.console_update([@big_bird, @dodo])
      @big_bird.reload.name.should == 'big birded'
      @dodo.reload.name.should == 'dudu'
    end
    
    test "doesn't modify missing attributes" do
      create_big_bird(:nickname=>'doofus')
      # this record is missing all it's attributes except name
      new_records = [{'name'=>'big birded', 'id'=>@big_bird.id}]
      stub_editor_update_with_records(new_records)
      Bird.console_update([@big_bird])
      @big_bird.reload.nickname.should == 'doofus'
      @big_bird.name.should == 'big birded'
    end
    
    test "updates attr_protected column" do
      create_big_bird
      new_records = [@big_bird.attributes.update('description'=>"it's big")]
      stub_editor_update_with_records(new_records)
      Bird.console_update([@big_bird])
      @big_bird.reload.description.should == "it's big"
    end
    
    test "rescues exception" do
      create_big_bird
      Bird.stub!(:system) {|*args| raise "error" }
      capture_stdout {
        Bird.console_update([@big_bird])
      }
    end
    
    test "via instance method" do
      create_big_bird
      stub_editor_update_with_records([@big_bird.attributes.update('name'=>'small bird')])
      @big_bird.console_update
      @big_bird.reload.name.should == 'small bird'
    end
    
    test "via find_and_console_update" do
      create_big_bird
      stub_editor_update_with_records([@big_bird.attributes.update('name'=>'small bird')])
      Bird.find_and_console_update(@big_bird.id)
      @big_bird.reload.name.should == 'small bird'
    end
    
    test "with only option only edits those columns" do
      create_big_bird(:description=>"something")
      stub_editor_update_with_records([@big_bird.attributes.update('name'=>'big birded')], :expected_attributes=>['id', 'name'])
      Bird.console_update([@big_bird], :only=>['name'])
      @big_bird.reload.name.should == 'big birded'
    end
    
    test "with except option edits all columns except those columns" do
      create_big_bird(:description=>"something")
      expected_attributes = ["id", "name", "nickname"]
      stub_editor_update_with_records([@big_bird.attributes.update('name'=>'big birded')], :expected_attributes=>expected_attributes)
      Bird.console_update([@big_bird], :except=>['description'])
      @big_bird.reload.name.should == 'big birded'
    end
    
    test "sets a non column attribute" do
      create_big_bird
      stub_editor_update_with_records([{'tag_list'=>["yellow"], 'id'=>@big_bird.id}], :expected_attributes=>["id","tag_list"])
      Bird.console_update([@big_bird], :only=>["tag_list"] )
      @big_bird.tag_list.should == ['yellow']
    end
    
    test "updates and deletes extra attributes added in editor" do
      create_big_bird
      stub_editor_update_with_records([{'name'=>'big birded','nickname'=>'doofird', 'id'=>@big_bird.id}])
      Bird.console_update([@big_bird], :only=>['name'])
      @big_bird.reload.nickname.should_not == 'doofird'
    end
  end
  
  test "editable_attribute_names expire per console_update" do
    create_big_bird
    stub_editor_update_with_records([{'name'=>'big birded', 'id'=>@big_bird.id}], :expected_attributes=>["id", "name"])
    Bird.console_update([@big_bird], :only=>['name'])
    @big_bird.instance_eval("@editable_attribute_names").should == nil
    #these expected_attributes would fail if @editable_attribute_names wasn't reset for each console_update()
    stub_editor_update_with_records([{'description'=>'big birded','id'=>@big_bird.id}], :expected_attributes=>["description", "id"])
    Bird.console_update([@big_bird], :only=>['description'])
  end
end
