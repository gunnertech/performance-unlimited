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
