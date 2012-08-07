module ProvidersConfig
end

Rails.application.config.middleware.use OmniAuth::Builder do
  PROVIDER_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/providers.yml")[::Rails.env]
  for p in PROVIDER_CONFIG['providers']
    if p['scope']
      provider p['name'], p['key'], p['secret'], scope: p['scope'], access_type: p['access_type'], approval_prompt: p['approval_prompt']
    else
      provider p['name'], p['key'], p['secret']
    end
    ProvidersConfig.const_set(p['name'].classify.upcase,{
      :key => p['key'],
      :secret => p['secret']
    })
    
    if p['name'] == 'twitter'
      Twitter.configure do |config|
        config.consumer_key = p['key']
        config.consumer_secret = p['secret']
      end
    end
  end
end
