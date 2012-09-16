class DivisionsController < InheritedResources::Base
  belongs_to :organization, optional: true
  belongs_to :user, optional: true
  
  custom_actions resource: :leaderboard
  layout :get_layout
  skip_load_and_authorize_resource only: :leaderboard
  
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
  
  def collection
    if parent.is_a? User
      @divisions ||= parent.admined_divisions
    else
      super
    end
    
  end
end
