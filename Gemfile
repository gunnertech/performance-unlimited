require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem "thin"
gem "squeel"
gem 'jquery-rails'
gem "devise", ">= 2.1.2"
gem "devise_invitable", ">= 1.0.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.1.0"
gem "sendgrid"
gem "will_paginate", ">= 3.0.3"
gem "inherited_resources"
gem "simple_form"
gem 'bootstrap-will_paginate'
gem "pg"
gem "modernizr-rails"
gem "has_scope"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "twitter-bootstrap-rails", ">= 2.0.3"
end

group :test, :development do
  gem 'sqlite3'
  gem "rspec-rails", ">= 2.11.0"
  gem "factory_girl_rails", ">= 3.5.0"
  gem "capybara"
end

group :development do
  gem "rails-footnotes", ">= 3.7"
  gem "guard", ">= 0.6.2"
  gem 'rb-fsevent'
  gem 'growl'
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-rspec", ">= 0.4.3"
  gem "heroku", "> 1.15.1" 
  gem "heroku-rails"
end

group :test do
  gem "email_spec"
end
