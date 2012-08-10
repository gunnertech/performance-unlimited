class Response < ActiveRecord::Base
  belongs_to :question
  has_one :organization, through: :question
  attr_accessible :long_text, :points, :short_text, :position
  
  acts_as_list scope: :question
  
  def to_s
    short_text
  end
end
