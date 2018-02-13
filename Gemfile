ruby '2.2.1'
source 'https://rubygems.org'

gem 'pg'
gem 'rails_12factor'
gem 'rails', '~>4.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'haml-rails'
gem 'faraday'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'pry-byebug'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'capybara'
  gem 'vcr'
  # gem 'selenium'
end

group :production do
  # gem 'rack-cache'
end
