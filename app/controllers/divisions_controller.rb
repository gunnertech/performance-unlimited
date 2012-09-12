class DivisionsController < InheritedResources::Base
  belongs_to :organization, optional: true
  custom_actions resource: :leaderboard
  layout :get_layout
  load_and_authorize_resource except: [:leaderboard]
  
  def create
    @division = Division.create(params[:division].merge(creator: current_user))
    @division.assigned_divisions.create(user: current_user)
    create!
  end
  
  def leaderboard
    authorize! :read, resource
    leaderboard!
  end
  
  protected

  def get_layout
    request.xhr? ? nil : 'application'
  end
end
