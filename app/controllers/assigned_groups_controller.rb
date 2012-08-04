class AssignedGroupsController < InheritedResources::Base
  belongs_to :user
  
  def destroy
    destroy!{ [resource.group.division, resource.group] }
  end
end
