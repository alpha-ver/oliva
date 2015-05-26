class CreateParseTasks < ActiveRecord::Migration
  def change
    create_table :parse_tasks do |t|

      t.string   :name
      t.integer  :user_id
      t.integer  :interval
      t.string   :base_url
      
      t.string   :x_link
      t.string   :r_link
      t.string   :g_link 
           
      t.string   :x_title
      t.string   :x_body
      t.string   :x_img
      t.string   :x_date
      t.json     :x_additional
      t.boolean  :active
      t.json     :out
      t.integer  :step


      t.datetime :next_at, :default => "now()"
      t.timestamps
    end
  end
end
