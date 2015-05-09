class CreateVkAccounts < ActiveRecord::Migration
  def change
    create_table :vk_accounts do |t|
      t.string :login
      t.string :pass
      t.string :phone
      t.boolean :active
      t.integer :status
      t.json :info
      t.integer :user_id
      t.integer :proxy_id
      t.string  :token

      t.timestamps
    end
  end
end
