class QuestionSet < ActiveRecord::Base
  translates :name, :description
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes
  
  belongs_to :organization
  
  has_many :assigned_question_sets
  has_many :assigned_questions, order: :position
  has_many :questions, through: :assigned_questions
  
  attr_accessible :description, :name
  
  def max_responses
    questions.max_by {|question| question.responses.count }.responses.count
  end
end

QuestionSet::Translation.class_eval do
  attr_accessible :locale, :name, :description
end