class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      
      t.string  :name
      t.string  :img_hash
      t.string  :img_type  
      t.string  :img_class
      t.integer :user_id

      t.timestamps
    end
    add_index :images, [:img_hash, :user_id], :unique => true 
  end
end
