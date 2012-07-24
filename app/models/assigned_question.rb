class AssignedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_set
  attr_accessible :position
end
