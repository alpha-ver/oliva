class Vk::Account < ActiveRecord::Base
  belongs_to :user, :class_name => User

  has_many :invites, :class_name => Vk::Invite

  validates :login, presence: true
  validates :pass, presence: true
end
