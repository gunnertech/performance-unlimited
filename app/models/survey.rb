class Survey < ActiveRecord::Base
  resourcify
  
  belongs_to :organization
  
  has_many :assigned_question_sets, order: :position
  has_many :question_sets, through: :assigned_question_sets
  
  has_many :assigned_surveys
  has_many :point_ranges, through: :assigned_surveys
  has_many :completed_surveys
  
  attr_accessible :name
  
  def to_s
    name
  end
end
