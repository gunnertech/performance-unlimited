class DivisionsController < InheritedResources::Base
  
  def create
    @division = Division.create(params[:division])
    @division.assigned_divisions.create(user: current_user)
    create!
  end
end
