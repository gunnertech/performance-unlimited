class AssignedDivisionsController < InheritedResources::Base
  belongs_to :user
  
  def index
    @assigned_divisions = AssignedDivision.accessible_by(current_ability)
  end
end
