class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  has_many :assigned_groups
  has_many :groups, through: :assigned_groups
  has_many :assigned_divisions
  has_many :divisions, through: :assigned_divisions
  has_many :completed_surveys
  
  def to_s
    name
  end
  
end
