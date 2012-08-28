class Question < ActiveRecord::Base
  translates :short_text, :long_text
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes
  
  belongs_to :organization
  
  has_many :assigned_questions
  has_many :question_sets, through: :assigned_questions
  has_many :responses, order: :position
  
  attr_accessible :long_text, :short_text
  
  def to_s
    short_text
  end
end

Question::Translation.class_eval do
  attr_accessible :locale, :short_text, :long_text
end