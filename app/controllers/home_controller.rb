class HomeController < ApplicationController
  skip_load_and_authorize_resource
  
  def index
    if signed_in?
      if @organization = Organization.with_role('admin', current_user).first
        if @organization.divisions.count == 1
          @division = @organization.divisions.find_by_name('Pittsburgh Pirates')
        elsif params[:division_id]
          @division = @organization.divisions.find(params[:division_id])
        end
      else
        @division = Division.with_role('athlete', current_user).first
        @organization = @division.organization
      end
      
      if @division
        @groups = @division.groups
        @grouped_users = @division.grouped_users
        @survey = @division.surveys.first
      end
    end
  end
end
