class Question < ActiveRecord::Base
  belongs_to :organization
  
  has_many :assigned_questions
  has_many :question_sets, through: :assigned_questions
  has_many :responses
  
  attr_accessible :long_text, :short_text
  
  def to_s
    short_text
  end
end
