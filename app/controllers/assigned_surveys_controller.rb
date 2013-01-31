class AssignedSurveysController < InheritedResources::Base
  belongs_to :division
  
  load_resource :division
  load_and_authorize_resource :assigned_survey, through: :division, except: [:index]
  
  
  before_filter :authorize_parent
  
  def create
    create!{ root_url }
  end
  
  
  protected
  def collection
    return @assigned_surveys if @assigned_surveys
    
    @assigned_surveys = end_of_association_chain.accessible_by(current_ability)
  end
end
