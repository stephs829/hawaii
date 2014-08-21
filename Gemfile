source 'https://rubygems.org'

gem 'rails', '4.0.5'

# Database
gem 'mysql2'
gem 'factual-api', :require => 'factual'

#Passwords
gem 'dotenv-rails', :groups => [:development, :test]

# Workers
gem 'sidekiq'
gem 'whenever', require: false
gem 'sinatra', require: false # required for sidekiq
gem 'slim'

# Model
gem 'mechanize'
gem 'nokogiri'
gem 'similar_text'

# Testing
group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'factory_girl'
end

#production
gem 'rails_12factor', group: :production

# Server
gem 'puma'
gem 'capistrano', group: :development

# UI
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'haml'
gem 'rabl'