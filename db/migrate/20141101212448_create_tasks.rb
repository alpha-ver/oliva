class CreateTasks < ActiveRecord::Migration
  def change
    create_table  :tasks do |t|
      t.string  :name
      t.json  :fi
      t.json  :ev
      t.integer :interval
      t.boolean :active
      t.integer  :user_id


      t.timestamps
    end

    add_index :tasks, :user_id
  end
end
