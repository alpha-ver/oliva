class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :registerable, :recoverable, :confirmable, :validatable, :invitable, :invite_for => 2.weeks
  
  has_many :avito_tasks,    :class_name => Avito::Task
  has_many :avito_postings, :class_name => Avito::Posting
  has_many :avito_accounts, :class_name => Avito::Account
  has_many :images

end
