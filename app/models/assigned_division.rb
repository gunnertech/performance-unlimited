class AssignedDivision < ActiveRecord::Base
  resourcify
  belongs_to :division
  belongs_to :user
  has_one :organization, through: :division
  
  attr_accessible :user, :division
  
  after_update :clean_up
  
  def to_s
    division.to_s
  end
  
  protected
  
  def clean_up
    self.destroy if self.division.nil?
  end
end
