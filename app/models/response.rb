class Response < ActiveRecord::Base
  translates :short_text, :long_text, :suggestion
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes
  
  belongs_to :question
  has_one :organization, through: :question
  attr_accessible :long_text, :points, :short_text, :position, :suggestion, :alert
  
  before_save :set_points_to_zero, if: proc { |response| response.question.measures_dimension? }
  
  acts_as_list scope: :question
  
  def to_s
    short_text
  end
  
  protected
  def set_points_to_zero
    self.points = 0
  end
end

Response::Translation.class_eval do
  attr_accessible :locale, :short_text, :long_text, :suggestion
end