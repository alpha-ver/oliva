class Vk::Invite < ActiveRecord::Base

  
  belongs_to :vk_account, :class => Vk::Account, :foreign_key => :vk_account_id
end
