class AssignedGroupsController < InheritedResources::Base
  belongs_to :user, optional: true
  
  def destroy
    destroy!{ params[:return_to].present? ? params[:return_to] : [resource.group.division, resource.group] }
  end
end
