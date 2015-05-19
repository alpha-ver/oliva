class Vk::Invite < ActiveRecord::Base
  belongs_to :vk_account, :class => Vk::Account
end
