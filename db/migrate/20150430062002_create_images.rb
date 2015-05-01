class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :hash
      t.string :class
      t.integer :user_id

      t.timestamps
    end
  end
end
