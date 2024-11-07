require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

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
    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.test_framework nil
    end

    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'

    # Add the following block to load production settings from production.yml
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'settings', 'production.yml')
      if File.exists?(env_file)
        settings = YAML.load_file(env_file)[Rails.env] || {}  # nilチェックを追加
        settings.each do |key, value|
          ENV[key.to_s] = value.to_s
        end
      end
    end
  end
end
