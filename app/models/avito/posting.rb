class Avito::Posting < ActiveRecord::Base
  belongs_to :user, :class_name => User


  validates :p, presence: true
  validates :e, presence: true
  validates :name, presence: true
end
