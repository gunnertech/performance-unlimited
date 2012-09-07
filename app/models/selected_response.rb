class SelectedResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :response
  belongs_to :completed_survey
  
  has_one :question, through: :response
  has_one :organization, through: :question
  
  attr_accessible :response, :user, :user_id, :response_id
  
  after_save :update_survey_score
  
  def score
    response.try(:points) || 0
  end
  
  def to_s
    response.to_s
  end
  
  def update_survey_score
    completed_survey.update_score
  end
end
