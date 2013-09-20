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
  
  def fix_recorded_on_parameter
    if params[:recorded_metric].present? && params[:recorded_metric][:recorded_on].present? && params[:recorded_metric][:recorded_on].match(/\//)
      params[:recorded_metric][:recorded_on] = DateTime.strptime(params[:recorded_metric][:recorded_on],'%m/%d/%Y')
    end
  end
end
