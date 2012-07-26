class Organization < ActiveRecord::Base
  resourcify
  
  has_many :divisions
  has_many :surveys
  has_many :question_sets
  has_many :questions
  
  attr_accessible :name
  
  def to_s
    name
  end
end
