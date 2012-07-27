class HomeController < ApplicationController
  def index
    @organization = Organization.first
    @division = @organization.divisions.find_by_name('Pittsburgh Pirates')
    @groups = @division.groups
    @users = @division.users
    @grouped_users = @division.grouped_users
    @survey = @division.surveys.first
  end
end
