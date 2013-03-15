class AssignedGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  has_one :division, through: :group
  has_one :organization, through: :group
  attr_accessible :position
  
  acts_as_list scope: :group
  
  validates :group_id, uniqueness: { scope: :user_id }
  
  def to_s
    "#{organization.to_s} (#{division.to_s}): #{group.to_s}"
  end
end
