class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :tasklogs, :id => false do |t|
      t.integer :i
      t.integer :task_id
      t.integer :module_id

      ############
      add_index :tasklogs, [:i, :task_id, :module_id], :unique => true 
      add_index :tasklogs, :task_id

      t.timestamps
    end
  end
end
