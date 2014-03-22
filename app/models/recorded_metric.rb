class RecordedMetric < ActiveRecord::Base
  belongs_to :user
  belongs_to :metric
  has_one :metric_type, through: :metric
  has_many :alerts, through: :metric
  has_many :organizations, through: :user
  has_many :assigned_alerts, dependent: :destroy
  
  attr_accessible :recorded_on, :value, :user, :user_id, :metric, :metric_id
  
  validates_uniqueness_of :recorded_on, scope: [:user_id,:metric_id]
  validates :value, presence: true
  validates :metric_id, presence: true
  validates :recorded_on, presence: true
  
  before_validation :set_numerical_value
  after_save :create_alerts
  
  class << self
    def current_for(metric_id)
      joins{ metric }.order{ recorded_on.desc }.where{ metric.id == metric_id }.limit(1)
    end
  end
  
  def create_alerts
    organizations.each do |organization|
      organization.alerts.where{ metric_id == my{ metric.id }}.each do |alert|
        if numerical_value && numerical_value <= alert.threshold_maximum && numerical_value >= alert.threshold_minimum
          assigned_alert = user.assigned_alerts.build
          assigned_alert.alert = alert
          assigned_alert.recorded_metric = self
          assigned_alert.date = recorded_on
          assigned_alert.save
        end
      end
    end
  end
  handle_asynchronously :create_alerts
  
  def set_numerical_value
    self.numerical_value = value.to_d unless metric_type.name == 'Text'
  end
end
