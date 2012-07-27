class Response < ActiveRecord::Base
  belongs_to :question
  attr_accessible :long_text, :points, :short_text
  
  acts_as_list scope: :question
end
