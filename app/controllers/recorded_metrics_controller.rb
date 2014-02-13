class RecordedMetricsController < InheritedResources::Base
  belongs_to :user, optional: true
  
  custom_actions collection: [:average]
  
  load_resource :user
  load_and_authorize_resource :recorded_metric, through: :user, except: [:index, :average]
  
  respond_to :json
  respond_to :js, only: [:average]
  
  prepend_before_filter :fix_recorded_on_parameter
  before_filter :set_dates, only: [:index,:average]
  before_filter :set_entity, only: [:average]
  
  
  before_filter :authorize_parent
  
  def create
    create! { parent }
  end
  
  def average
    
  end
  
  def update
    update! { parent }
  end
  
  protected
  
  def set_entity
    if params[:organization_id].present?
      @entity = Organization.find(params[:organization_id])
    elsif params[:division_id].present?
      @entity = Division.find(params[:division_id])
    elsif params[:group_id].present?
      @entity = Group.find(params[:group_id])
    end
  end
  
  def set_dates
    params[:start_date] ||= 1.year.ago
    params[:end_date] ||= Date.today
    
    params[:start_date] = params[:start_date].is_a?(String) ? DateTime.strptime(params[:start_date],'%m/%d/%Y') : params[:start_date]
    params[:end_date] = params[:end_date].is_a?(String) ? DateTime.strptime(params[:end_date],'%m/%d/%Y') : params[:end_date]
  end
  
  def collection
    return @recorded_metrics if @recorded_metrics
    
    @recorded_metrics = end_of_association_chain.accessible_by(current_ability)
    @recorded_metrics = @recorded_metrics.joins{ metric }.where{ metric.name == my{params[:name]}} if params[:name].present?
    if params[:most_recent].present?
      unique_metric_names = @recorded_metrics.joins{ metric }.select{distinct(`metrics.name`).as('metric_name')}.map(&:metric_name)
      ids = []
      unique_metric_names.each do |metric_name|
        ids.push(@recorded_metrics.joins{ metric }.where{ metric.name == my{metric_name} }.reorder{ recorded_on.desc }.limit(1).first.try(:id))
      end
      
      @recorded_metrics = @recorded_metrics.where{ id >> my{ids.compact}}
    else
      @recorded_metrics = @recorded_metrics.where{ recorded_on >> my{params[:start_date]..params[:end_date]}}
    end
    
    # raise @recorded_metrics.joins{ metric }.where{metric.name == 'Weight'}.count.to_s
    
    @recorded_metrics
  end
  
  def fix_recorded_on_parameter
    if params[:recorded_metric].present? && params[:recorded_metric][:recorded_on].present? && params[:recorded_metric][:recorded_on].match(/\//)
      params[:recorded_metric][:recorded_on] = DateTime.strptime(params[:recorded_metric][:recorded_on],'%m/%d/%Y')
    end
  end
end
