class CreateAvitoPostings < ActiveRecord::Migration
  def change
    create_table :avito_postings do |t|
      t.string     :name,                      default: nil, null: false
      t.integer    :interval
      t.boolean    :active
      t.boolean    :allow_mail

      #############
      t.json     :title
      t.json     :description
      t.json     :manager
      t.json     :price
      t.json     :images
      #############

      #############
      t.json       :p
      t.json       :e
      #############
      t.integer    :count      
      t.integer    :user_id
      
      #############
      t.datetime   :next_at, :default => "now()"
      t.json       :response
      t.timestamps
    end
    add_index :avito_postings, :user_id
  end
end
