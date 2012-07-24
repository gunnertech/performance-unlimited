class CompletedSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  attr_accessible :date
end
