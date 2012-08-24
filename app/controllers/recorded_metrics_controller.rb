class RecordedMetricsController < InheritedResources::Base
  belongs_to :user
  
  def create
    create! { parent }
  end
  
  def update
    update! { parent }
  end
end
