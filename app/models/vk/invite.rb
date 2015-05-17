class Vk::Invite < ActiveRecord::Base
  belongs_to :vk_account, :class_name => Vk::Account
end
