class CompletedSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  has_many :selected_responses
  has_many :questions, through: :survey
  
  validates_uniqueness_of :date, scope: :user_id
  
  attr_accessible :date, :user, :user_id, :score
  
  default_scope order('date DESC')
  
  def as_json(options = {})
    super options.merge(methods: [:score])
  end
  
  def to_s
    survey.to_s
  end
  
  def update_score
    update_attributes(score: selected_responses.map(&:score).inject(:+))
  end
end
