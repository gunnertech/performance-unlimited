class Organization < ActiveRecord::Base
  resourcify
  has_attached_file :logo, { default_url: "/assets/logos/:style/missing.png", default_style: :medium,   styles: { medium: "250x200#", thumb: "125x100#" }}.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  has_many :divisions
  has_many :surveys
  has_many :question_sets
  has_many :questions
  has_many :authentications, as: :authenticationable
  
  attr_accessible :name, :logo
  
  def connected_to_twitter?
    twitter_accounts.count > 0
  end
  
  def twitter_accounts
    authentications.where{ provider == 'twitter' }
  end
  
  def google_accounts
    authentications.where{ provider == 'google_oauth2' }
  end
  
  def upload_spreadsheets(spreadsheet_as_string, title)
    client = OAuth2::Client.new(ProvidersConfig::GOOGLEOAUTH2[:key], ProvidersConfig::GOOGLEOAUTH2[:secret], site: OAUTH_SITE_URL, token_url:'https://accounts.google.com/o/oauth2/token'); 
    
    google_accounts.each do |account|
      token = OAuth2::AccessToken.new(client,account.token,refresh_token: account.refresh_token)
      if token.expired?
        token = token.refresh!
      end
      begin
        session = GoogleDrive.login_with_oauth(token)
        session.upload_from_string(spreadsheet_as_string, title, convert: true )
      rescue
        token = token.refresh!
        session = GoogleDrive.login_with_oauth(token)
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
      @client.user(screen_name).profile_image_url
    end
  end
  
  def to_s
    name
  end
end
