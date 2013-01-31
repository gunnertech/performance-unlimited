class RecordedMetric < ActiveRecord::Base
  belongs_to :user
  belongs_to :metric
  has_many :organizations, through: :user
  
  attr_accessible :recorded_on, :value, :user, :user_id, :metric, :metric_id
  
  validates_uniqueness_of :recorded_on, scope: [:user_id,:metric_id]
  
  class << self
    def current_for(metric_id)
      joins{ metric }.order{ recorded_on.desc }.where{ metric.id == metric_id }.limit(1)
    end
  end
end
