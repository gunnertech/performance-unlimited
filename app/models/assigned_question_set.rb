class AssignedQuestionSet < ActiveRecord::Base
  belongs_to :question_set
  belongs_to :survey
  
  has_one :organization, through: :question_set
  
  has_many :questions, through: :question_set
  
  acts_as_list scope: :survey
  
  attr_accessible :position, :question_set_attributes
  
  accepts_nested_attributes_for :question_set
  
  delegate :assigned_questions, :assigned_questions=, to: :question_set, allow_nil: true
  
  def to_s
    name
  end
  
  def name
    question_set.name
  end
end
