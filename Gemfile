source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'

# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# user login
gem 'devise'
# 更換devise flash message語言
gem "rails-i18n"
# 網頁驗證機制
gem "recaptcha", require: "recaptcha/rails"
# 檢查代碼風格
gem 'rubocop', '~> 0.49.0'
# HTTP Request
gem 'rest-client'
# google登入
gem 'omniauth'
gem 'omniauth-google-oauth2'
# GA
gem 'google-api-client'
# FB API
gem "koala"
# export xls
gem 'spreadsheet'
# 固定排程
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 1'
gem 'sinatra', :require => nil

# web scraping
gem 'mechanize'

# CI
gem 'rollbar'

# Debug
gem "pry"

# CSS
gem "animate-rails"
gem 'bootstrap-sass', '~> 3.3.7'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem "font-awesome-rails"
gem 'jquery-peity-rails'
gem 'jquery-rails'
gem 'jquery-slimscroll-rails'
gem 'jquery-ui-rails'
gem 'metismenu-rails', github: 'lanvige/metismenu-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'pace-rails', git: 'git@github.com:yovu/pace-rails.git'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # 自動化部屬
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.1.5', '< 3.2'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  # GCP use mySQL
  gem 'mysql2', '~> 0.4.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
