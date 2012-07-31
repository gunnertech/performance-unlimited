class GroupsController < InheritedResources::Base
  belongs_to :division, optional: true
  respond_to :json
end
