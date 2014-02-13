class OrganizationsController < InheritedResources::Base
  before_filter :create_session_variable, only: :show
  before_filter :set_record_date, only: [:show, :upload_performance_data]
  before_filter :set_users, only: [:show, :download_performance_template, :dashboard]
  before_filter :set_dates, only: :dashboard
  before_filter :set_metrics, only: :dashboard
  before_filter :set_hide_averages, only: :dashboard
  before_filter :set_graph_type
  
  custom_actions resource: [:upload_performance_data,:download_performance_template,:dashboard]
  skip_load_and_authorize_resource only: [:upload_performance_data, :index,:dashboard]
  
  respond_to :csv, only: :download_performance_template
  
  def download_performance_template
    authorize! :create, RecordedMetric
    today = Time.now.to_date
    response.headers['Content-Disposition'] = "attachment; filename=\"performance-template-#{today}.csv\""
  end
  
  def dashboard
    authorize! :create, RecordedMetric
    dashboard!
  end
  
  def upload_performance_data
    require 'csv'
    authorize! :create, RecordedMetric
    if !params[:file].content_type.match(/csv/) && !params[:file].content_type.match(/comma/) && !params[:file].content_type.match(/application\/vnd\.ms\-excel/)
      flash[:error] = "You tried to upload a #{params[:file].content_type} file. You can only upload csv files. To save an excel file as csv, just choose 'Save As...' and then pick 'CSV'"
      redirect_to resource and return false
    end
    
    resource.file_contents = File.read(params[:file].tempfile, mode:'r:ISO-8859-1')
    resource.recorded_date = params[:recorded_date]
    resource.save!
    
    flash[:notice] = "Your file is processing and will be ready momentarily"
    redirect_to resource_url(record_date: params[:recorded_date])
  end
  
  def add_authentication
    @organization = Organization.find(params[:organization_id] || session[:organization_id])
    if auth_hash[:provider] == 'twitter'
      @organization.authentications.create(
        provider: 'twitter',
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        nickname: auth_hash[:info][:nickname]
      )
    elsif auth_hash[:provider] == 'google_oauth2'
      @organization.authentications.create(
        provider: 'google_oauth2',
        uid: auth_hash[:uid],
        refresh_token: auth_hash[:credentials][:refresh_token],
        token: auth_hash[:credentials][:token],
        nickname: auth_hash[:info][:name]
      )
    end
    
    redirect_to @organization
  end
  
  protected
  
  def set_hide_averages
    params[:hide_averages] = params[:hide_averages].present? ? params[:hide_averages] : 1
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
  
  def create_session_variable
    session[:organization_id] = params[:id]
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
  
  def set_graph_type
    params[:graph_type] ||= 'line'
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
  
  def set_metrics
    @metrics = resource.metrics.joins{ metric_type }
    @metrics = @metrics.where{ metric_type.name == 'Text' } if params[:graph_type] == 'table'
    @metrics = @metrics.where{ metric_type.name != 'Text' } if params[:graph_type] != 'table'
    @metrics = @metrics.where{ id != my{params[:focus_graph]} } if params[:focus_graph].present?
    @focus_metric = resource.metrics.where{ id == my{params[:focus_graph]}}.first if params[:focus_graph].present?
  end
  
  def set_users
    if action_name == 'download_performance_template'
      @users = resource.users
    else
      params[:letter] ||= 'a'
      @users = User.where{ (id >> my{resource.users.pluck('users.id')}) & (last_name =~ my{"#{params[:letter]}%"}) }.order{ [last_name.asc, first_name.asc] }
    end
  end
  
end
