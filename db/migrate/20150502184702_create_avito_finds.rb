class CreateAvitoFinds < ActiveRecord::Migration
  def change
    create_table :avito_finds do |t|
      t.json :req
      t.json :res

      t.integer :user_id

      t.timestamps
    end
  end
end
