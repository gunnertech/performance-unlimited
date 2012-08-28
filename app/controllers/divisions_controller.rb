class DivisionsController < InheritedResources::Base
  belongs_to :organization, optional: true
  
  def create
    @division = Division.create(params[:division].merge(creator: current_user))
    @division.assigned_divisions.create(user: current_user)
    create!
  end
end
