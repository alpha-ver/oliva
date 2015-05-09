class AddFieldUser < ActiveRecord::Migration
  def change
    #antigate
    add_column :users, :antigate_key,    :string,   default: nil
    add_column :users, :antigate_money,  :integer,  default: 0

  end
end
