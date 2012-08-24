class Metric < ActiveRecord::Base
  belongs_to :metric_type
  belongs_to :organization
  
  has_many :recorded_metrics
  attr_accessible :decimal_places, :name, :metric_type, :metric_type_id
  
  def to_s
    name
  end
end
