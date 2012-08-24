class MetricsController < InheritedResources::Base
  belongs_to :organization
  
  def create
    create!{ parent }
  end
  
  def update
    update!{ parent }
  end
end
