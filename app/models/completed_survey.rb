class CompletedSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  has_many :selected_responses
  
  attr_accessible :date, :user, :user_id
  
  default_scope order('date DESC')
  
  def to_s
    survey.to_s
  end
  
  def score
    selected_responses.map(&:score).inject(:+)
  end
end
