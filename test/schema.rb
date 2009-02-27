ActiveRecord::Schema.define(:version => 0) do
  create_table :birds do |t|
    t.string  :name, :nickname
    t.text :description
    t.timestamps
    t.binary :bin
  end
end
