class HomeController < ApplicationController
  def index
    @organization = Organization.first
    @division = @organization.divisions.find_by_name('Pittsburgh Pirates')
    @groups = @division.groups
    @users = @division.users
    @grouped_users = []
    @survey = @division.surveys.first
    
    0.upto((@users.size/@groups.count).ceil-1).each do |row|
      @grouped_users[row] ||= []
      @groups.each_with_index do |group,i|
        @grouped_users[row][i] ||= []
        @grouped_users[row][i].push(@users.joins{ groups }.where{ groups.id >> group.id }.to_a)
        @grouped_users[row][i].flatten!
      end
    end
  end
end
