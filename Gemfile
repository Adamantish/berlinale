ruby '2.3.0'
source 'https://rubygems.org'

gem 'pg'
gem 'rails_12factor', group: :production
gem 'rails', github: "rails/rails"

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'geocoder'
gem 'haml-rails'
gem 'underscore-rails'
gem 'httparty'
gem 'devise', github: 'plataformatec/devise'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'pry-byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'capybara'
  # gem 'selenium'
end
