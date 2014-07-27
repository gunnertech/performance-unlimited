class HomeController < ApplicationController

  def index
    @mapped_domain = MappedDomain.find_by_domain(request.domain.to_s) || MappedDomain.find_by_domain(DEFAULT_DOMAIN)
    @organization = @mapped_domain.organization
    # authorize! :read, @organization
    
    @possible_organizations = Organization.with_role('admin', current_user)
    @possible_divisions = Division.where{ id >> my{Organization.with_role('admin', current_user).joins{ divisions }.pluck('divisions.id')}}
    @possible_groups = Group.where{ id >> my{Organization.with_role('admin', current_user).joins{ groups }.pluck('groups.id')}}
    
    if @organization
      if params[:survey_id]
        @survey = @organization.surveys.find(params[:survey_id])
        @division = current_user.default_division
        @groups = @division.groups
        @biggest_group_count, @total_groups, @user_array, @group_array = @division.grouped_users
        # @grouped_users = @division.grouped_users
      elsif params[:division_id]
        @division = @organization.divisions.find(params[:division_id])
      elsif current_user.default_division
        @division = current_user.default_division
        @organization = @division.organization
      elsif current_user.has_role?('admin', @organization)
        if @organization.divisions.count == 1
          @division = @organization.divisions.first
        end
      else
        @division = Division.with_role('athlete', current_user).first
      end
      
      if @division.present? && @survey.nil?
        @groups = @division.groups
        # @grouped_users = @division.grouped_users
        @biggest_group_count, @total_groups, @user_array, @group_array = @division.grouped_users
        @survey = @division.surveys.where{ active == true }.first
      end
    end
  end
end
