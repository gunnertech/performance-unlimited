class AssignedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_set
  
  attr_accessible :position, :question_set
  
  def to_s
    question.to_s
  end
end
