class Division < ActiveRecord::Base
  belongs_to :organization
  has_many :groups
  has_many :users, through: :groups
  
  has_many :assigned_surveys
  has_many :surveys, through: :assigned_surveys
  
  attr_accessible :name
end
