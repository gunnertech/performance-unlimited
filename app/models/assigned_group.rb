class AssignedGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  has_one :organization, through: :group
  # attr_accessible :title, :body
end
