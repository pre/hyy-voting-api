module Haka
  class Engine < ::Rails::Engine
    isolate_namespace Haka

    # Bundler does not require dependencies recursively.
    # Engine's dependencies must be required here.
    # https://github.com/bundler/bundler/issues/49
    require 'ruby-saml'

    # Load .env.test for Engine's own tests.
    # Production & development env variables are loaded from parent project.
    if ENV['RAILS_ENV'] == 'test'
      require 'dotenv-rails'
      Dotenv.load('.env.test')
    end

    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
