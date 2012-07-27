class SelectedResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :response
  belongs_to :completed_survey
  
  attr_accessible :response, :user, :user_id, :response_id
  
  def score
    response.try(:points) || 0
  end
end
