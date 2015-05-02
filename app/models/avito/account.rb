class Avito::Account < ActiveRecord::Base
  belongs_to :user, :class_name => User

  validates :login, presence: true
  validates :pass, presence: true
end
