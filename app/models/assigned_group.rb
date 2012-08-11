class AssignedGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  has_one :organization, through: :group
  attr_accessible :position
  
  acts_as_list scope: :group
end
