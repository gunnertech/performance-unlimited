class PointRangesController < InheritedResources::Base
  belongs_to :assigned_survey
  
  load_resource :assigned_survey
  load_and_authorize_resource :point_range, through: :assigned_survey, except: [:index]
  
  
  before_filter :authorize_parent
  
  def create
    create!{ division_assigned_survey_url(parent.division,parent) }
  end
  
  def update
    update!{ division_assigned_survey_url(parent.division,parent) }
  end
  
  protected
  def collection
    return @point_ranges if @point_ranges
    
    @point_ranges = end_of_association_chain.accessible_by(current_ability)
  end
  
end
