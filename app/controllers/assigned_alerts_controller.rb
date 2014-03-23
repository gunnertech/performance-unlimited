class AssignedAlertsController < InheritedResources::Base
  belongs_to :user
  
  respond_to :json
  
  protected
  
  def collection
    return @assigned_alerts if @assigned_alerts
    
    @assigned_alerts = end_of_association_chain.accessible_by(current_ability)
    
    @assigned_alerts = AssignedAlert.where{ id >> my{@assigned_alerts.pluck('id').uniq} }
    
    @assigned_alerts = @assigned_alerts.joins{ recorded_metric }.reorder{ recorded_metric.recorded_on.desc }
    
    @assigned_alerts
  end
end
