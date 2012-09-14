class HomeController < ApplicationController
  skip_load_and_authorize_resource
  
  def index
    if signed_in?
      if params[:division_id] && @organization = Organization.with_role('admin', current_user).first
        @division = @organization.divisions.find(params[:division_id])
      elsif current_user.default_division
        @division = current_user.default_division
        @organization = @division.organization
      elsif @organization = Organization.with_role('admin', current_user).first
        if @organization.divisions.count == 1
          @division = @organization.divisions.find_by_name('Pittsburgh Pirates')
        end
      else
        @division = Division.with_role('athlete', current_user).first
        @organization = @division.try(:organization)
      end
      
      if @division
        @groups = @division.groups
        @grouped_users = @division.grouped_users
        @survey = @division.surveys.where{ active == true }.first
      end
    end
  end
end
