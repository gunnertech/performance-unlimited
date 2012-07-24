class PointRange < ActiveRecord::Base
  belongs_to :assigned_survey
  attr_accessible :description, :high, :low
end
