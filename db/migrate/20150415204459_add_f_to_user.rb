class AddFToUser < ActiveRecord::Migration
  def change
    add_column :avito_postings, :s, :json, default: {}, null: false
  end
end
