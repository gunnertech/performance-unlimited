class AssignedDivision < ActiveRecord::Base
  resourcify
  belongs_to :division
  belongs_to :user
  has_one :organization, through: :division
  
  attr_accessible :user, :division
  
  def to_s
    division.to_s
  end
end
