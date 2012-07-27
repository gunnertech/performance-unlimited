class AssignedQuestionSet < ActiveRecord::Base
  belongs_to :question_set
  belongs_to :survey
  
  has_many :questions, through: :question_set
  
  acts_as_list scope: :survey
  
  attr_accessible :position
  
  def to_s
    name
  end
  
  def name
    question_set.name
  end
end
