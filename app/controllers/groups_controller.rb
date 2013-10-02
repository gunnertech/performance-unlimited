class GroupsController < InheritedResources::Base
  belongs_to :division, optional: true
  
  before_filter :set_record_date, only: [:show, :upload_performance_data]
  before_filter :set_users, only: [:show, :download_performance_template, :dashboard]
  before_filter :set_dates, only: :dashboard
  before_filter :set_metrics, only: :dashboard
  before_filter :set_graph_type
  
  layout :get_layout
  
  custom_actions resource: [:leaderboard, :upload_performance_data,:download_performance_template,:dashboard]
  skip_load_and_authorize_resource only: [:leaderboard, :upload_performance_data, :index,:dashboard]
  
  respond_to :csv, only: :download_performance_template
  respond_to :json
  
  def download_performance_template
    authorize! :create, RecordedMetric
    today = Time.now.to_date
    response.headers['Content-Disposition'] = "attachment; filename=\"performance-template-#{today}.csv\""
  end
  
  def dashboard
    authorize! :create, RecordedMetric
    dashboard!
  end
  
  def show
    show! do |success|
      success.html
      success.csv {
        today = Time.now.in_time_zone(parent.time_zone).to_date
        start_date = Date.strptime(params[:start_date], "%m/%d/%Y") rescue (today-30.days)
        end_date = Date.strptime(params[:end_date], "%m/%d/%Y") rescue today
        
        @dates = (start_date..end_date).map{ |date| date }
        response.headers['Content-Disposition'] = "attachment; filename=\"#{parent.name.parameterize}-#{@group.name.parameterize}-#{today}.csv\""
      }
    end
  end
  
  protected
  
  def set_dates
    params[:start_date] ||= 1.year.ago.to_date.strftime("%m/%d/%Y")
    params[:end_date] ||= Date.today.strftime("%m/%d/%Y")
    
    params[:start_date] = params[:start_date].is_a?(String) ? DateTime.strptime(params[:start_date],'%m/%d/%Y') : params[:start_date]
    params[:end_date] = params[:end_date].is_a?(String) ? DateTime.strptime(params[:end_date],'%m/%d/%Y') : params[:end_date]
    
    params[:start_date] = params[:start_date].strftime("%m/%d/%Y")
    params[:end_date] = params[:end_date].strftime("%m/%d/%Y")
  end

  def get_layout
    request.xhr? ? nil : 'application'
  end
  
  def collection
    return @divisions if @divisions
    @divisions = end_of_association_chain.accessible_by(current_ability)
    
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
