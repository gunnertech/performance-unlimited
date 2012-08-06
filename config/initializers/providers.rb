module ProvidersConfig
end

Rails.application.config.middleware.use OmniAuth::Builder do
  PROVIDER_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/providers.yml")[::Rails.env]
  for p in PROVIDER_CONFIG['providers']
    if p['options']
      provider p['name'], p['key'], p['secret'], :scope => p['options']
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
