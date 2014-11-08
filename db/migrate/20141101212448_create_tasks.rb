class CreateTasks < ActiveRecord::Migration
  def change
    create_table  :tasks do |t|
      t.string  :name
      t.string  :stat

      ###################
      t.integer :count, :default => 0
      t.integer :interval
      t.boolean :active, :default => false
      t.integer :counter
      ##################
      t.json    :p
      t.json    :e
      ##################
      t.integer :user_id #<= μαγεία fo potato ;) 
      ##################
      t.datetime   :next_at, :default => "now()"
      t.timestamps
    end

    add_index :tasks, :user_id
  end
end
