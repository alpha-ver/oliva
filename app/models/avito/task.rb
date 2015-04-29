class Avito::Task < ActiveRecord::Base

  belongs_to :user, :class_name => User
  has_many :avito_tasklogs, :class_name => Avito::Tasklog


  validates :p, presence: true
  validates :e, presence: true
  
end
