class UsersController < InheritedResources::Base
  belongs_to :group, optional: true
  respond_to :csv, only: :show
  
  def create
    if parent?
      @user = User.create(params[:user])
      if @user.valid?
        parent.users << @user
      end
      create!{ [parent.division, parent] }
    else
      create!
    end
  end
  
  
  def show
    show! do |success|
      success.html
      success.csv {
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@user.name.parameterize}-#{Date.today}.csv\""
      }
    end
  end
end
