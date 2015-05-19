class Vk::Account < ActiveRecord::Base
  belongs_to :user, :class => User

  has_many :vk_invites, :class_name => Vk::Invite

  validates :login, presence: true
  validates :pass, presence: true
end
