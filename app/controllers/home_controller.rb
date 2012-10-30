class HomeController < ApplicationController
  skip_load_and_authorize_resource
  
  def index
    @mapped_domain = MappedDomain.find_by_domain(request.domain.to_s) || MappedDomain.find_by_domain(DEFAULT_DOMAIN)
    @organization = @mapped_domain.organization
    if signed_in? && @organization
      if params[:survey_id]
        #@organization = Organization.with_role('admin', current_user).first
        @survey = @organization.surveys.find(params[:survey_id])
        @division = current_user.default_division
        @groups = @division.groups
        @grouped_users = @division.grouped_users
      elsif params[:division_id] # && @organization = Organization.with_role('admin', current_user).first
        @division = @organization.divisions.find(params[:division_id])
      elsif current_user.default_division
        @division = current_user.default_division
        @organization = @division.organization
      elsif current_user.has_role?('admin', @organization) # @organization = Organization.with_role('admin', current_user).first
        if @organization.divisions.count == 1
          @division = @organization.divisions.find_by_name('Pittsburgh Pirates')
        end
      else
        @division = Division.with_role('athlete', current_user).first
        #@organization = @division.try(:organization)
      end
      
      if @division && @survey.nil?
        @groups = @division.groups
        @grouped_users = @division.grouped_users
        @survey = @division.surveys.where{ active == true }.first
      end
    end
  end
end
