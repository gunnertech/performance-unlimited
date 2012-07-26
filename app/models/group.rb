class Group < ActiveRecord::Base
  belongs_to :division
  has_many :assigned_groups
  has_many :users, through: :assigned_groups
  
  attr_accessible :name
  
  def to_s
    name
  end
end
