class PointRangesController < InheritedResources::Base
  belongs_to :assigned_survey
  
  def create
    create!{ division_assigned_survey_url(parent.division,parent) }
  end
  
  def update
    update!{ division_assigned_survey_url(parent.division,parent) }
  end
end
