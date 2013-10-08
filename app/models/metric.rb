class Metric < ActiveRecord::Base
  belongs_to :metric_type
  belongs_to :organization
  has_many :alerts
  
  has_many :recorded_metrics, dependent: :destroy
  attr_accessible :decimal_places, :name, :metric_type, :metric_type_id, :note
  
  validates :metric_type, presence: true
  validates :name, presence: true
  
  def to_s
    name
  end
end
