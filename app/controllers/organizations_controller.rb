class OrganizationsController < InheritedResources::Base
  before_filter :create_session_variable, only: :show
  before_filter :set_record_date, only: [:show, :upload_performance_data]
  
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
    file_contents = File.read(params[:file].tempfile, mode:'r:ISO-8859-1')
    rows = CSV.parse(file_contents, :headers => true)
    rows.headers.each_with_index do |header,i|
      if i > 2 && resource.metrics.where{ lower(name) == my{header.downcase} }.first.nil?
        resource.metrics.create(name: header, metric_type: MetricType.find_or_create_by_name('Number'))
      end
    end
    (rows||[]).each_with_index do |row, i|
      next if row['First Name'].blank?
      user = nil
      if row['Athlete ID'].present?
        user = User.find_by_id(row['Athlete ID'])
      else
        user = resource.users.where{ (first_name == my{row['First Name']}) & (last_name == my{row['Last Name']}) }.first
      end
      
      if row['Groups'].present?
        pieces = row['Groups'].split(":")
        division = resource.divisions.find_or_create_by_name(pieces.first)
        group = division.groups.find_or_create_by_name(pieces.last)
        
        user.groups << group unless user.groups.include?(group)
      end
      
      if user.nil?
        group = Group.find(params[:group_id])
        user = User.new(first_name: row['First Name'], last_name: row['Last Name'])
        user.save!
        user.add_role('athlete', group)
        group.users << user
      end
      
      rows.headers.each_with_index do |header,i|
        if i > 2
          if row[header].present?
            metric = resource.metrics.where{ lower(name) == my{header.downcase} }.first
            begin
              if row[header].match(/%/)
                row[header] = (row[header].gsub(/%/,"").to_f / 100)
                m = resource.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Percentage').id
                m.save!
              elsif row[header].match(/[a-z]/i)
                m = resource.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Text').id
                m.save!
              end
              metric.recorded_metrics.create!(value: row[header], recorded_on: params[:recorded_date], user: user)
            rescue
              #raise metric.to_s
            end
          end
        end
      end
    end
    
    flash[:notice] = "Data successfully processed!"
    redirect_to resource
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
  
  def create_session_variable
    session[:organization_id] = params[:id]
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
  
  def set_record_date
    
    if params[:recorded_date].present?
      params[:recorded_date] = DateTime.strptime(params[:recorded_date],'%m/%d/%Y')
    else
      params[:recorded_date] ||= Date.today
    end
    
    
    if params[:record_date].present?
      params[:record_date] = DateTime.strptime(params[:record_date],'%m/%d/%Y')
    else
      params[:record_date] ||= Date.today
    end
  end
  
end
