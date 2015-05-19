class Vk::AccountGroup < ActiveRecord::Base

  belongs_to :user,    :class => User
  belongs_to :vk_find, :class => Vk::Find, :foreign_key => :find_id

  has_many   :vk_accounts, :class_name => Vk::Account, :foreign_key => :vk_account_group_id
  
end
