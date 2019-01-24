source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.2'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'turbolinks'
gem 'bootsnap', require: false
gem 'jquery-rails'
gem 'bootstrap'
gem 'stripe'
gem 'rest-client'
gem 'resque'
gem 'octicons'
gem 'nested_form_fields'
gem 'active_model_serializers'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'dotenv-rails'
  gem 'hirb'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
end

group :test do
  gem 'stripe-ruby-mock', :require => 'stripe_mock'
end
