class UsersController < InheritedResources::Base
  belongs_to :group, optional: true
  belongs_to :organization, optional: true
  belongs_to :division, optional: true
  respond_to :csv, only: :show
  # before_filter :set_users, only: :dashboard
  before_filter :set_dates, only: :dashboard
  before_filter :set_metrics, only: :dashboard
  before_filter :set_graph_type
  
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
  
  def set_metrics
    metric_ids = resource.metrics.pluck('metrics.id').uniq
    
    @metrics = Metric.joins{ metric_type }.where{ id >> my{metric_ids}}
    @metrics = @metrics.where{ metric_type.name == 'Text' } if params[:graph_type] == 'table'
    @metrics = @metrics.where{ metric_type.name != 'Text' } if params[:graph_type] != 'table'
    @metrics = @metrics.where{ id != my{params[:focus_graph]} } if params[:focus_graph].present?
    @focus_metric = resource.metrics.where{ id == my{params[:focus_graph]}}.first if params[:focus_graph].present?
  end
  
  def set_dates
    params[:start_date] = params[:graph_start_date] if params[:graph_start_date].present? && params[:start_date].blank?
    params[:end_date] = params[:end_start_date] if params[:end_start_date].present? && params[:end_date].blank?
    
    params[:start_date] ||= 1.year.ago.to_date.strftime("%m/%d/%Y")
    params[:end_date] ||= Date.today.strftime("%m/%d/%Y")
    
    params[:start_date] = params[:start_date].is_a?(String) ? DateTime.strptime(params[:start_date],'%m/%d/%Y') : params[:start_date]
    params[:end_date] = params[:end_date].is_a?(String) ? DateTime.strptime(params[:end_date],'%m/%d/%Y') : params[:end_date]
    
    params[:start_date] = params[:start_date].strftime("%m/%d/%Y")
    params[:end_date] = params[:end_date].strftime("%m/%d/%Y")
  end
  
  def set_graph_type
    params[:graph_type] ||= 'line'
  end
end
