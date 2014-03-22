class Alert < ActiveRecord::Base
  belongs_to :metric
  has_many :recorded_metrics, through: :metric
  belongs_to :alertable, polymorphic: true
  attr_accessible :alertable_id, :alertable_type, :date, :message, :threshold_maximum, :threshold_minimum
  validates :message, presence: true
  validates :threshold_minimum, presence: true
  validates :threshold_maximum, presence: true
  
  after_create :add_alerts
  
  
  def add_alerts
    recorded_metrics.find_in_batches do |group|
      sleep(5)
      group.each { |recorded_metric| recorded_metric.create_alerts unless recorded_metric.assigned_alerts.count > 0 }
    end
  end
  handle_asynchronously :add_alerts
  
end
