source 'http://rubygems.org'

gem 'rails', '3.0.1'
gem 'pg'
gem 'twitter'
gem 'omniauth'
gem 'transitions', :require => ["transitions", "active_record/transitions"]
gem 'dynamic_form'

# Deploy with Capistrano
gem 'capistrano'

group :test do
  gem 'mocha', :require => false
  gem 'factory_girl'
  gem 'turn'
  gem 'vcr'
  gem 'fakeweb'
end

group :test, :development do
  gem 'ruby-debug19'
end
