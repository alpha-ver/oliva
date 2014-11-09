class Task < ActiveRecord::Base

  belongs_to :user
  has_many :tasklogs


  validates :p, presence: true
  validates :e, presence: true
  
end
