class CreateVkAccountGroups < ActiveRecord::Migration
  def change
    create_table :vk_account_groups do |t|
      t.string :name
      t.boolean :cross
      t.integer :cross_ids, array: true, default: []
      t.integer :find_id
      t.integer :user_id
      t.boolean :active #@todo

      t.timestamps
    end
  end
end
