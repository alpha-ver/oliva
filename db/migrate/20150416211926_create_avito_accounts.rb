class CreateAvitoAccounts < ActiveRecord::Migration
  def change
    create_table :avito_accounts do |t|
      t.string  :login
      t.string  :pass
      t.integer :status,        default: 0,   null: false
      t.integer :user_id,       default: nil, null: false
      t.json    :f,             default: {},  null: false

      t.timestamps
    end
    add_index :avito_accounts, :login, unique: true
  end
end
