source 'https://rubygems.org'

ruby '2.3.1' # This is for Heroku, it's defined also in .ruby-version for RVM

gem 'rails', '~> 5.0'

gem 'puma', '~> 3.0' # application server

gem 'grape'
gem 'grape-entity'
gem 'nokogiri'

gem 'cancancan' #, '~> 1.10'

gem 'ranked-model'

# # Disable the security feature of strong_params at the model layer,
# # use Grape's own params validation instead.
# gem 'hashie-forbidden_attributes'
#
gem 'pg' # Postgres
gem 'rack-cors'
gem 'jwt'
gem 'pry-rails'

gem 'rollbar'
gem 'oj' # Rollbar suggestion for JSON serialization if not using JRuby
gem 'rails_12factor'

gem 'haka', path: 'engines/haka' # CSC Haka sign in

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen' #, '~> 3.0.5'  ## WAS LOCKED TO 3.1 BEFORE RAILS5
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop', require: false

  gem "letter_opener", :group => :development # open a sent email browser

  gem 'grape_on_rails_routes' # display grape routes: `rake grape:routes`

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
