class Survey < ActiveRecord::Base
  belongs_to :organization
  
  has_many :assigned_question_sets
  has_many :question_sets, through: :assigned_question_sets
  
  attr_accessible :name
end
