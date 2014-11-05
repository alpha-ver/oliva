class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :tasklogs, :id => false do |t|
      t.integer :i
      t.integer :task_id
      t.integer :module_id

      ############
      t.timestamps
    end
  end
end
