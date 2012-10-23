class SurveysController < InheritedResources::Base
  def index
    @surveys = Survey.with_role('admin', current_user)
  end
end
