class AssignedAlert < ActiveRecord::Base
  belongs_to :user
  belongs_to :alert
  belongs_to :recorded_metric
  has_one :metric, through: :alert
  has_many :organizations, through: :recorded_metric
  
  attr_accessible :cleared, :date
  
  validates :user_id, uniqueness:  {scope: [:alert_id,:date]}
  
  def as_json(options = {})
    super options.merge(include: {alert:{}, user:{}, metric:{}, recorded_metric:{}})
  end
  
  class << self
    def recent_for(user)
      AssignedAlert.where{ (created_at > my{user.last_sign_in_at}) & (user_id >> my{user.users.pluck('users.id')})}
    end
  end
  
end
