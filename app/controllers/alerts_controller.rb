class AlertsController < InheritedResources::Base
  belongs_to :metric
  prepend_before_filter :set_alertable
  
  def create
    create!{ [parent.organization,parent] }
  end
  
  def update
    update!{ [parent.organization,parent] }
  end
  
  protected
  
  def set_alertable
    if params[:alertable_type].present? && params[:alertable_id].present?
      @alertable = params[:alertable_type].classify.constantize.find(params[:alertable_id]) rescue nil
    end
  end
end
