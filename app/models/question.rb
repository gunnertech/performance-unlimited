class Question < ActiveRecord::Base
  translates :short_text, :long_text
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes
  
  belongs_to :organization
  
  has_many :assigned_questions
  has_many :question_sets, through: :assigned_questions
  has_many :responses, order: :position
  
  attr_accessible :long_text, :short_text, :organization, :organization_id, :measures_dimension
  
  after_save :set_organization
  
  def to_s
    short_text
  end
  
  protected
  
  def set_organization
    self.update_attributes(organization: assigned_questions.first.try(:organization)) unless self.organization
    true
  end
end

Question::Translation.class_eval do
  attr_accessible :locale, :short_text, :long_text
end