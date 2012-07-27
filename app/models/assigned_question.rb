class AssignedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_set
  has_many :assigned_question_sets, through: :question_set
  
  attr_accessible :position, :question_set, :question_attributes
  
  acts_as_list scope: :question_set
  
  accepts_nested_attributes_for :question
  
  def to_s
    question.to_s
  end
end
