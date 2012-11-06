class PointRangesController < InheritedResources::Base
  belongs_to :assigned_survey
  
  def create
    create!{ parent_url }
  end
  
  def update
    update!{ parent_url }
  end
end
