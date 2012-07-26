class UsersController < InheritedResources::Base
  belongs_to :group, optional: true
  
  def create
    if parent?
      @user = User.create(params[:user])
      parent.users << @user
    end
    create!
  end
end
