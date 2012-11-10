class PointRange < ActiveRecord::Base
  belongs_to :assigned_survey
  has_one :survey, through: :assigned_survey
  has_one :organization, through: :assigned_survey
  
  attr_accessible :description, :high, :low, :name
end
