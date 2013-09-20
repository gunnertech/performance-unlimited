class UsersController < InheritedResources::Base
  belongs_to :group, optional: true
  belongs_to :organization, optional: true
  belongs_to :division, optional: true
  respond_to :csv, only: :show
  
  custom_actions resource: [:dashboard]
  skip_load_and_authorize_resource only: [:dashboard]
  
  def dashboard
    authorize! :create, RecordedMetric
    dashboard!
  end
  
  def new
    @user = parent? ? parent.users.build : User.new
    @user.group_ids = [parent.id] if parent?
    new!
  end
  
  def create
    @user = User.find_by_email(params[:user][:email])
    if @user and parent?
      
      parent.users << @user if !parent.users.include?(@user)
      
      redirect_to [parent.division, parent]
    else
      @user = User.create(params[:user])
      @user.editor = current_user
      
      if parent?
        # if @user.valid?
        #   parent.users << @user
        #   #@user.add_role 'athlete', parent.division
        # end
        create!{ [parent.division, parent] }
      else
        create!
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user.editor = current_user
    if params[:password].blank?
      @user.update_without_password(params[:user])
    else
      @user.update(params[:user])
    end
    
    update!
  end
  
  
  def show
    @completed_surveys = resource.completed_surveys.joins{ survey }.where{ survey.active == true }.paginate(:page => params[:page])
    show! do |success|
      success.html
      success.csv {
        I18n.locale = :en
        today = Time.now.in_time_zone(@user.time_zone).to_date
        title = "#{@user.name.parameterize}-#{today}.csv"
        @dates = ((today-30.days)..today).map{ |date| date }
        @user.organizations.each do |organization|
          organization.upload_spreadsheets(render_to_string(template: 'users/show.csv.erb'), title)
        end
        
        response.headers['Content-Disposition'] = "attachment; filename=\"#{title}\""
      }
    end
  end
  
  protected
  
  def collection
    return @users if @users
    @users = end_of_association_chain.accessible_by(current_ability).paginate(:page => params[:page])
  end
end
