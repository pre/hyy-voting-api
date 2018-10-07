source 'https://rubygems.org'

ruby '2.5.1' # This is for Heroku, it's defined also in .ruby-version for RVM

gem 'rails', '~> 5.0.7'

gem 'puma', '~> 3.0' # application server

gem 'grape' # API
gem 'grape-entity'
gem 'nokogiri'
gem 'cancancan' # Authorization
gem 'pg' # Postgres
gem 'rack-cors'
gem 'jwt' # API tokens
gem 'pry-rails' # Better Rails console
gem 'pry-highlight' # pretty print json in console, usage: ">>"
gem 'rollbar' # Error reporting to Rollbar.com
gem 'oj' # Rollbar suggestion for JSON serialization if not using JRuby
gem 'ruby-saml' # Haka authentication
gem 'delayed_job_active_record' # background jobs, eg. email sending
gem 'jbuilder' # JSON builder

group :development, :test do
  gem 'byebug', platform: :mri # usage: write 'debugger' anywhere in code
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'selenium-webdriver', '3.0.0.beta2.1'
  gem 'faker'
  gem 'database_cleaner'
end

group :development do
  gem 'foreman'
  gem 'listen' #, '~> 3.0.5'  ## WAS LOCKED TO 3.1 BEFORE RAILS5
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Atom: Install linter-rubocop
  gem 'rubocop', require: false

  gem "letter_opener", :group => :development # open a sent email browser

  gem 'grape_on_rails_routes' # display grape routes: `rake grape:routes`

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
