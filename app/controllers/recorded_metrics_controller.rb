class RecordedMetricsController < InheritedResources::Base
  belongs_to :user
  
  load_resource :user
  load_and_authorize_resource :recorded_metric, through: :user, except: [:index]
  
  respond_to :json
  
  
  before_filter :authorize_parent
  
  def create
    create! { parent }
  end
  
  def update
    update! { parent }
  end
end
