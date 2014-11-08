class CreateTasks < ActiveRecord::Migration
  def change
    create_table  :tasks do |t|
      t.string  :name
      t.string  :stat

      t.integer :interval
      t.boolean :active
      t.integer :counter
      ##################
      t.json    :p
      t.json    :e
      ##################
      t.integer :user_id


      t.timestamps
    end

    add_index :tasks, :user_id
  end
end
