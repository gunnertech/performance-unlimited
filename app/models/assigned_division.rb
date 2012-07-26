class AssignedDivision < ActiveRecord::Base
  resourcify
  belongs_to :division
  belongs_to :user
  
  attr_accessible :user, :division
  
  def to_s
    division.to_s
  end
end
