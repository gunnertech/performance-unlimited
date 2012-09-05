class AssignedSurvey < ActiveRecord::Base
  belongs_to :survey
  belongs_to :division
  
  has_one :organization, through: :division
  
  has_many :point_ranges
  attr_accessible :survey, :survey_id, :division, :division_id
end
