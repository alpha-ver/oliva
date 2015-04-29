class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :avito_tasklogs, :id => false do |t|
      t.integer :i
      t.integer :task_id
      t.integer :module_id
    end
    
    add_index :avito_tasklogs, [:i, :task_id, :module_id], :unique => true 
    add_index :avito_tasklogs, :task_id    
  end
end
