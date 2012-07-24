class Organization < ActiveRecord::Base
  resourcify
  
  has_many :divisions
  has_many :surveys
  has_many :question_sets
  
  attr_accessible :name
end
