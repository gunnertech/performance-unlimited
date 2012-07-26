class Survey < ActiveRecord::Base
  belongs_to :organization
  
  has_many :assigned_question_sets
  has_many :question_sets, through: :assigned_question_sets
  
  has_many :assigned_surveys
  has_many :point_ranges, through: :assigned_surveys
  
  attr_accessible :name
end
