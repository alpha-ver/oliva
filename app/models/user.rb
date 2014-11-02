class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :confirmable, :invitable, :invite_for => 2.weeks

  has_many :tasks

end
