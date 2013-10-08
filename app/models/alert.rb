class Alert < ActiveRecord::Base
  belongs_to :metric
  belongs_to :alertable, polymorphic: true
  attr_accessible :alertable_id, :alertable_type, :date, :message, :threshold_maximum, :threshold_minimum
  validates :message, presence: true
  validates :threshold_minimum, presence: true
  validates :threshold_maximum, presence: true
  
end
