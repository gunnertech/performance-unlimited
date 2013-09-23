class RecordedMetricsController < InheritedResources::Base
  belongs_to :user
  
  load_resource :user
  load_and_authorize_resource :recorded_metric, through: :user, except: [:index]
  
  respond_to :json
  
  prepend_before_filter :fix_recorded_on_parameter
  
  
  before_filter :authorize_parent
  
  def create
    create! { parent }
  end
  
  def update
    update! { parent }
  end
  
  protected
  
  def collection
    return @recorded_metrics if @recorded_metrics
    
    @recorded_metrics = end_of_association_chain.accessible_by(current_ability)
    @recorded_metrics = @recorded_metrics.joins{ metric }.where{ metric.name == my{params[:name]}} if params[:name].present?
    
    
    @recorded_metrics
  end
  
  def fix_recorded_on_parameter
    if params[:recorded_metric].present? && params[:recorded_metric][:recorded_on].present? && params[:recorded_metric][:recorded_on].match(/\//)
      params[:recorded_metric][:recorded_on] = DateTime.strptime(params[:recorded_metric][:recorded_on],'%m/%d/%Y')
    end
  end
end
