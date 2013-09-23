class DivisionsController < InheritedResources::Base
  belongs_to :organization, optional: true
  # belongs_to :user, optional: true
  before_filter :set_record_date, only: [:show, :upload_performance_data]
  before_filter :set_users, only: [:show, :download_performance_template]
  
  layout :get_layout
  
  custom_actions resource: [:leaderboard, :upload_performance_data,:download_performance_template,:dashboard]
  skip_load_and_authorize_resource only: [:leaderboard, :upload_performance_data, :index,:dashboard]
  
  respond_to :csv, only: :download_performance_template
  
  def download_performance_template
    authorize! :create, RecordedMetric
    today = Time.now.to_date
    response.headers['Content-Disposition'] = "attachment; filename=\"performance-template-#{today}.csv\""
  end
  
  def create
    @division = Division.create(params[:division].merge(creator: current_user))
    @division.assigned_divisions.create(user: current_user)
    create!
  end
  
  def dashboard
    authorize! :create, RecordedMetric
    dashboard!
  end
  
  def leaderboard
    authorize! :read, resource
    leaderboard!
  end
  
  protected

  def get_layout
    request.xhr? ? nil : 'application'
  end
  
  def collection
    return @divisions if @divisions
    @divisions = end_of_association_chain.accessible_by(current_ability)
    
  end
  
  def set_users
    params[:letter] ||= 'a'
    @users = User.where{ (id >> my{resource.users.pluck('users.id')}) & (last_name =~ my{"#{params[:letter]}%"}) }.order{ [last_name.asc, first_name.asc] }
  end
  
  def set_record_date
    if params[:recorded_date].present? && params[:recorded_date].to_s.match(/\//)
      params[:recorded_date] = DateTime.strptime(params[:recorded_date],'%m/%d/%Y')
    else
      params[:recorded_date] ||= Date.today
      if params[:recorded_date].is_a?(String)
        params[:recorded_date] = Date.parse(params[:recorded_date])
      end
    end
    
    
    if params[:record_date].present? && params[:record_date].to_s.match(/\//)
      params[:record_date] = DateTime.strptime(params[:record_date],'%m/%d/%Y')
    else
      params[:record_date] ||= Date.today
      if params[:record_date].is_a?(String)
        params[:record_date] = Date.parse(params[:record_date])
      end
    end
    
    
  end
end
