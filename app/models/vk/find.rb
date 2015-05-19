class Vk::Find < ActiveRecord::Base
  belongs_to :user, :class => User

  has_many   :vk_account_groups,  :class_name => Vk::AccountGroup
end

