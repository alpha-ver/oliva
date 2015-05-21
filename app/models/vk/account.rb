class Vk::Account < ActiveRecord::Base
  belongs_to :user, :class => User

  has_one :vk_invite, :class_name => Vk::Invite,  :foreign_key => :vk_account_id

  validates :login, presence: true
  validates :pass, presence: true
end
