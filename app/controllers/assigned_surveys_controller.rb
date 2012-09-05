class AssignedSurveysController < InheritedResources::Base
  belongs_to :division
  
  def create
    create!{ root_url }
  end
end
