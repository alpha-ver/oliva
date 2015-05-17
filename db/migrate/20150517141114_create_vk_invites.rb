class CreateVkInvites < ActiveRecord::Migration
  def change
    create_table :vk_invites do |t|
      t.string :name
      t.integer :interval
      t.integer :vk_account_id
      t.integer :invite_ids, array: true, default: []
      t.integer :invited_ids, array: true, default: []
      t.integer :find_ids, array: true, default: []
      t.boolean :active
      t.integer :status
      

      t.json :e
      t.datetime :next_at, :default => "now()"

      
      t.timestamps
    end
  end
end
