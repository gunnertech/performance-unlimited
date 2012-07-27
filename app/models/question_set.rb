class QuestionSet < ActiveRecord::Base
  belongs_to :organization
  
  has_many :assigned_question_sets
  has_many :assigned_questions, order: :position
  has_many :questions, through: :assigned_questions
  
  attr_accessible :description, :name
  
  def max_responses
    questions.max_by {|question| question.responses.count }.responses.count
  end
end
