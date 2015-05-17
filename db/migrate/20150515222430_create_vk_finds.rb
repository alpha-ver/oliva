class CreateVkFinds < ActiveRecord::Migration
  def change
    create_table :vk_finds do |t|
      t.string   :name
      t.json     :p
      t.integer  :user_id
      t.integer  :vk_account_ids, array: true, default: []
      t.integer  :count
      t.integer  :find_count
      t.integer  :step_count
      t.json     :map_find
      t.integer  :error_code
      t.integer  :interval
      
      t.boolean  :active
      t.integer  :find_ids, array: true, default: []
      
      t.datetime :next_at, :default => "now()"
      t.timestamps
    end
    add_index :vk_finds, :user_id
  end
end
