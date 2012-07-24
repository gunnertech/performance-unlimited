class AssignedSurvey < ActiveRecord::Base
  belongs_to :survey
  belongs_to :division
  # attr_accessible :title, :body
end
