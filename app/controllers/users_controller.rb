class UsersController < InheritedResources::Base
  belongs_to :group, optional: true
  respond_to :csv, only: :show
  
  def create
    if parent?
      @user = User.create(params[:user])
      if @user.valid?
        parent.users << @user
        @user.add_role 'athlete', parent.division
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
        title = "#{@user.name.parameterize}-#{Date.today}.csv"
        @dates = (30.days.ago.to_date..Date.today).map{ |date| date }
        @user.organizations.each do |organization|
          organization.upload_spreadsheets(render_to_string(template: 'users/show.csv.erb'), title)
        end
        
        response.headers['Content-Disposition'] = "attachment; filename=\"#{title}\""
      }
    end
  end
end
