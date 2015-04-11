class CreateAdminPostings < ActiveRecord::Migration
  def change
    create_table :admin_postings do |t|
      t.string :title
      t.string :description
      t.string :manager
      t.string :price
      t.string :images
      t.string :p
      t.integer :count
      t.boolean :active
      t.boolean :allow_mail
      ##################
      t.json    :p
      t.json    :e
      ##################
      t.integer :user_id
      ##################
      t.datetime   :next_at, :default => "now()"
      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
