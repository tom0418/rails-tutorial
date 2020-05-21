source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.4.2'

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'carrierwave'
gem 'coffee-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'mini_magick'
gem 'mysql2'
gem 'puma'
gem 'sass-rails'
gem 'turbolinks'
gem 'uglifier'
gem 'will_paginate'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debase'
  gem 'faker'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby-debug-ide'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'rails-controller-testing'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
