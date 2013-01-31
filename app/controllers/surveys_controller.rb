class SurveysController < InheritedResources::Base
  
  protected
  
  def collection
    return @surveys if @surveys
    @surveys = end_of_association_chain.accessible_by(current_ability)
    
  end
end
