class HomeController < ApplicationController

  def index
    @mapped_domain = MappedDomain.find_by_domain(request.host.to_s) || MappedDomain.find_by_domain(DEFAULT_DOMAIN)
    @organization = @mapped_domain.organization
    authorize! :read, @organization unless signed_in?

    if current_user.is_an_admin?
      @possible_organizations = Organization.with_role('admin', current_user)
      @possible_divisions = Division.where{ id >> my{Organization.with_role('admin', current_user).joins{ divisions }.pluck('divisions.id')}}
      @possible_groups = Group.where{ id >> my{Organization.with_role('admin', current_user).joins{ groups }.pluck('groups.id')}} 
    else
      @division = current_user.default_division || current_user.divisions.first
      @survey = params[:survey_id].present? ? @division.organization.surveys.find(params[:survey_id]) : @division.surveys.where{ active == true }.first
      @survey = Survey.find(3)
    end
  
  end
end
