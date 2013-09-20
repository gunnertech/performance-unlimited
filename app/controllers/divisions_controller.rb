class DivisionsController < InheritedResources::Base
  belongs_to :organization, optional: true
  # belongs_to :user, optional: true
  
  custom_actions resource: [:leaderboard,:dashboard]
  layout :get_layout
  skip_load_and_authorize_resource only: [:leaderboard, :index,:dashboard]
  
  def create
    @division = Division.create(params[:division].merge(creator: current_user))
    @division.assigned_divisions.create(user: current_user)
    create!
  end
  
  def dashboard
    authorize! :create, RecordedMetric
    dashboard!
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
    return @divisions if @divisions
    @divisions = end_of_association_chain.accessible_by(current_ability)
    
  end
end
