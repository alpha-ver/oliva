class CreateParseDbs < ActiveRecord::Migration
  def change
    create_table :parse_dbs do |t|
      t.integer :task_id
      t.string  :url

      t.string :title
      t.text   :body
      t.string :img
      t.string :date
      t.string :additional
      t.json   :info 

      t.timestamps
    end
    add_index :parse_dbs, [:url, :task_id], unique: true
  end
end
