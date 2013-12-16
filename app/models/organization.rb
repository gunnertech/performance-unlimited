class Organization < ActiveRecord::Base
  resourcify
  has_attached_file :logo, { default_url: "/assets/logos/:style/missing.png", default_style: :medium,   styles: { medium: "250x200#", thumb: "125x100#" }}.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  has_many :divisions
  has_many :surveys
  has_many :assigned_surveys, through: :surveys
  has_many :point_ranges, through: :assigned_surveys
  has_many :completed_surveys, through: :surveys
  has_many :assigned_question_sets, through: :surveys
  has_many :question_sets
  has_many :questions
  has_many :authentications, as: :authenticationable
  has_many :users, through: :divisions
  has_many :metrics
  has_many :assigned_locales
  has_many :locales, through: :assigned_locales
  has_many :mapped_domains
  has_many :recorded_metrics, through: :users
  has_many :groups, through: :divisions
  has_many :alerts, as: :alertable
  has_many :assigned_alerts, through: :recorded_metrics
  has_many :comments, through: :metrics
  
  has_many :responses, through: :questions
  
  attr_accessible :name, :logo, :file, :file_contents
  attr_accessor :file, :recorded_date
  
  before_save :start_upload, if: Proc.new{|resource| resource.file_contents.present? }
  
  def organization
    self
  end
  
  def start_upload
    do_upload(recorded_date)
  end
  
  def do_upload(recorded_date)
    require 'csv'
    begin
      rows = CSV.parse(file_contents, :headers => true)
    rescue
      return false
    end
    rows.headers.each_with_index do |header,i|
      if header.present? && i > 3 && self.metrics.where{ lower(name) == my{header.downcase} }.first.nil?
        self.metrics.create(name: header, metric_type: MetricType.find_or_create_by_name('Number'))
      end
    end
    (rows||[]).each_with_index do |row, i|
      next if row['First Name'].blank?
      user = nil
      groups = []
      
      if row['Groups'].present?
        (row['Groups'].split(",")||[]).each do |piece|
          pieces = piece.split(":")
          division = self.divisions.find_or_create_by_name(pieces.first)
          group = division.groups.find_or_create_by_name(pieces.last)
          groups.push(group) unless groups.include?(group)
        end
        
      end
      
      if row['Athlete ID'].present?
        user = User.find_by_id(row['Athlete ID'])
      else
        user = self.users.where{ (first_name == my{row['First Name'].try(:squish)}) & (last_name == my{row['Last Name'].try(:squish)}) }.first
      end
      
      if user.nil?
        user = User.new(first_name: row['First Name'].try(:squish), last_name: row['Last Name'].try(:squish))
        user.save!
      end
      
      if groups.empty?
        division ||= self.divisions.find_or_create_by_name('Primary')
        group = division.groups.find_or_create_by_name("Primary")
        groups.push(group)
      end
      
      groups.each do |group|
        user.add_role('athlete', group) unless user.has_role?('athlete',group)
        user.groups << group unless user.groups.include?(group)
      end
      
      
      rows.headers.each_with_index do |header,i|
        if i > 3
          if row[header].present?
            metric = self.metrics.where{ lower(name) == my{header.downcase} }.first
            begin
              if row[header].match(/%/)
                row[header] = (row[header].gsub(/%/,"").to_f / 100)
                m = self.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Percentage').id
                m.save!
              elsif row[header].to_s.squish.present? && row[header].to_s.gsub(/\./,"").match(/\D/)
                m = self.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Text').id
                m.save!
              end
              metric.recorded_metrics.create!(value: row[header], recorded_on: recorded_date, user: user)
            rescue
              #raise metric.to_s
            end
          end
        end
      end
    end
    self.file_contents = nil
    self.save!
  end
  handle_asynchronously :do_upload, run_at: Proc.new { 1.minutes.from_now }
  
  def connected_to_twitter?
    twitter_accounts.count > 0
  end
  
  def twitter_accounts
    authentications.where{ provider == 'twitter' }
  end
  
  def google_accounts
    authentications.where{ provider == 'google_oauth2' }
  end
  
  def upload_spreadsheets(spreadsheet_as_string, title, delete_last = true)
    client = OAuth2::Client.new(ProvidersConfig::GOOGLEOAUTH2[:key], ProvidersConfig::GOOGLEOAUTH2[:secret], site: OAUTH_SITE_URL, token_url:'https://accounts.google.com/o/oauth2/token'); 
    
    google_accounts.each do |account|
      token = OAuth2::AccessToken.new(client,account.token,refresh_token: account.refresh_token)
      if token.expired?
        token = token.refresh!
      end
      begin
        session = GoogleDrive.login_with_oauth(token)
        
        if delete_last
          session.spreadsheet_by_title(title).delete rescue nil
        end
        
        session.upload_from_string(spreadsheet_as_string, title, convert: true )
      rescue
        token = token.refresh!
        session = GoogleDrive.login_with_oauth(token)
        
        if delete_last
          session.spreadsheet_by_title(title).delete rescue nil
        end
        
        session.upload_from_string(spreadsheet_as_string, title, convert: true )
      end
    end
    
  end
  
  def tweets_for(screen_name)
    tweets = nil
    authentication = authentications.where{ (provider == 'twitter') && (nickname == screen_name) }.first
    if authentication
      @client = Twitter::Client.new(
        oauth_token: authentication.token,
        oauth_token_secret: authentication.secret
      )
      tweets = @client.user_timeline(screen_name, count: 5) rescue nil
    end
    
    if tweets
      Rails.cache.fetch("tweets_for", expires_in: 1.hour) do
        tweets
      end
    else
      []
    end
  end
  
  def twitter_description(screen_name)
    authentication = authentications.where{ (provider == 'twitter') && (nickname == screen_name) }.first
    if authentication
      @client = Twitter::Client.new(
        oauth_token: authentication.token,
        oauth_token_secret: authentication.secret
      )
      @client.user(screen_name).description
    end
  end
  
  def twitter_profile_image_src(screen_name)
    authentication = authentications.where{ (provider == 'twitter') && (nickname == screen_name) }.first
    if authentication
      @client = Twitter::Client.new(
        oauth_token: authentication.token,
        oauth_token_secret: authentication.secret
      )
      @client.user(screen_name).profile_image_url rescue ""
    end
  end
  
  def to_s
    name
  end
end
