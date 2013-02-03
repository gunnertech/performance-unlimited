class CompletedSurvey < ActiveRecord::Base
  self.per_page = 10
  
  belongs_to :user
  belongs_to :survey
  
  has_one :organization, through: :survey
  
  after_create :send_alerts
  after_save :update_user_score
  
  
  has_many :selected_responses
  has_many :questions, through: :survey
  has_many :responses, through: :selected_responses
  
  validates_uniqueness_of :date, scope: :user_id
  
  attr_accessible :date, :user, :user_id, :score
  
  default_scope order{ date.desc }
  
  def as_json(options = {})
    super options.merge(methods: [:score])
  end
  
  def to_s
    survey.to_s
  end
  
  def update_score
    update_attributes(score: responses.sum('responses.points'))
  end
  
  def update_user_score
    user.update_score
  end
  
  def send_alerts
    AlertMailer.notification_email(self).deliver if selected_responses.joins{ response }.where{ response.suggestion != nil && response.alert == true }.count
  end
end
