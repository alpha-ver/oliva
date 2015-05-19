class CreateAccountGroupId < ActiveRecord::Migration
  def change
    add_column :vk_accounts, :vk_account_group_id, :integer
  end
end
