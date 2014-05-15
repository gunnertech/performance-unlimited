class Metric < ActiveRecord::Base
  belongs_to :metric_type
  belongs_to :organization
  has_many :alerts
  has_many :comments
  
  has_many :recorded_metrics, dependent: :destroy
  has_many :users, through: :recorded_metrics
  attr_accessible :decimal_places, :name, :metric_type, :metric_type_id, :note, :position
  
  validates :metric_type, presence: true
  validates :name, presence: true
  
  acts_as_list scope: :organization
  
  before_save :set_position, if: Proc.new{|metric| metric.position_changed? }
  
  def to_s
    name
  end
  
  def set_position
    insert_at(position)
  end
  
  def recorded_for(user)
    if user.is_a?(Array)
      recorded_metrics.where{ user_id >> my{user} }
    else
      recorded_metrics.where{ user_id == my{user.id}}
    end
  end
end
