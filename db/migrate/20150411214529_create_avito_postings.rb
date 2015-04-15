class CreateAvitoPostings < ActiveRecord::Migration
  def change
    create_table :avito_postings do |t|
      t.string     :title,        array: true, default: []
      t.string     :description,  array: true, default: []
      t.string     :manager,      array: true, default: []
      t.string     :price,        array: true, default: []
      t.string     :images,       array: true, default: []
      #############
      t.boolean    :active
      t.boolean    :allow_mail
      #############
      t.json       :p
      t.json       :e
      #############
      t.integer    :count      
      t.integer    :user_id
      #############
      t.datetime   :next_at, :default => "now()"
      t.timestamps
    end
    add_index :avito_postings, :user_id
  end
end
