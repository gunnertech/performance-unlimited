class RecordedMetric < ActiveRecord::Base
  belongs_to :user
  belongs_to :metric
  has_one :metric_type, through: :metric
  has_many :organizations, through: :user
  
  attr_accessible :recorded_on, :value, :user, :user_id, :metric, :metric_id
  
  validates_uniqueness_of :recorded_on, scope: [:user_id,:metric_id]
  validates :value, presence: true
  validates :metric_id, presence: true
  validates :recorded_on, presence: true
  
  before_validation :set_numerical_value
  
  class << self
    def current_for(metric_id)
      joins{ metric }.order{ recorded_on.desc }.where{ metric.id == metric_id }.limit(1)
    end
  end
  
  def set_numerical_value
    self.numerical_value = value.to_d unless metric_type.name == 'Text'
  end
end
