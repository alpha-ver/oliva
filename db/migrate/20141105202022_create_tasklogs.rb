class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :tasklogs, :id => false do |t|
      t.integer :i
      t.integer :task_id
      t.integer :module_id
    end
    
    add_index :tasklogs, [:i, :task_id, :module_id], :unique => true 
    add_index :tasklogs, :task_id    
  end
end
