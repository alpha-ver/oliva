class Avito::Task < ActiveRecord::Base

  belongs_to :user
  has_many :avito_tasklogs


  validates :p, presence: true
  validates :e, presence: true
  
end
