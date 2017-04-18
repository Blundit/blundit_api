require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blundit
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.browserify_rails.paths << /vendor\/assets\/javascripts\/module\.js/

    # Environments in which to generate source maps
    #
    # The default is none
    config.browserify_rails.source_map_environments << "development"
    config.browserify_rails.commandline_options = "-t coffeeify --extension=\".js.coffee\""

    config.sass.preferred_syntax = :sass
    config.sass.line_comments = false
    config.sass.cache = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any, 
          :expose => ['Access-Token', 'Expiry', 'Token-Type', 'Uid', 'Client'],
          :methods => [:get, :post, :patch, :delete, :options, :put]
      end
    end
  end
end

