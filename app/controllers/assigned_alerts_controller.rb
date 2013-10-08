class AssignedAlertsController < InheritedResources::Base
  belongs_to :user
  
  respond_to :json
  
  def collection
    return @assigned_alerts if @assigned_alerts
    
    @assigned_alerts = end_of_association_chain.accessible_by(current_ability)
    
    @assigned_alerts
  end
end
