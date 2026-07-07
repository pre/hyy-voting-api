require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'rack/auth/basic'

# HTTP Basic auth fence for staging environments.
#
# This must be Rack middleware: the Grape API is mounted directly in
# `config/routes.rb` and bypasses Rails controllers, so controller-level
# `http_basic_authenticate_with` never covered `/api/*`.
#
# API clients authenticate with an "Authorization: Bearer <jwt>" header and
# thus cannot also send Basic credentials, so requests with a Bearer header
# pass through here and JWT auth is enforced downstream by the API.
class BasicAuthFence
  def initialize(app, username, password)
    @app = app
    @basic_auth = Rack::Auth::Basic.new(app) do |user, pass|
      Rack::Utils.secure_compare(user, username) &
        Rack::Utils.secure_compare(pass, password)
    end
  end

  def call(env)
    return @app.call(env) if env['HTTP_AUTHORIZATION'].to_s.start_with?('Bearer ')

    @basic_auth.call(env)
  end
end

module HyyVotingApi
  class Application < Rails::Application
    # Read ENV directly: this file is loaded before the initializers which
    # define `Vaalit::Config::HTTP_BASIC_AUTH_USERNAME`.
    unless ENV['HTTP_BASIC_AUTH_USERNAME'].to_s.empty?
      config.middleware.use BasicAuthFence,
                            ENV['HTTP_BASIC_AUTH_USERNAME'],
                            ENV['HTTP_BASIC_AUTH_PASSWORD']
    end


    config.active_support.cache_format_version = 7.1

    config.active_job.queue_adapter = :delayed_job

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
