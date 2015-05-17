class CreateVkUsers < ActiveRecord::Migration
  def change
    create_table :vk_users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :sex
      t.integer :status
      t.integer :city_id
      t.integer :country_id
      t.integer :friend_ids, array: true, default: []
      t.integer :friend_count
      t.boolean :private_message

      t.timestamps
    end
  end
end
