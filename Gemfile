source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.4'

gem 'puma'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'grape'
gem 'grape-entity'
gem 'nokogiri'

# Active Admin
gem 'activeadmin', '~> 1.0.0.pre2' # N.B. pre-release! needed for Rails 4
gem 'devise'
gem 'cancancan'
gem 'draper'
gem 'pundit'

gem 'ranked-model'

# Disable the security feature of strong_params at the model layer,
# use Grape's own params validation instead.
gem 'hashie-forbidden_attributes'

gem 'pg'
gem 'rack-cors'
gem 'jwt'
gem 'pry-rails'

gem 'rollbar', '~> 2.5.1'
gem 'oj', '~> 2.12.14' # Rollbar suggestion for JSON serialization if not using JRuby

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rubocop', require: false
end
