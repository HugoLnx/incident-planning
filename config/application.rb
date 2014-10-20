require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module IncidentPlanning
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    I18n.enforce_available_locales = true

    config.autoload_paths << Rails.root.join("app", "models")
    config.autoload_paths << Rails.root.join("app", "models", "**")
    config.autoload_paths << Rails.root.join("app", "models", "**", "*.rb")

    config.assets.precompile += [
      "analysis_matrices.js", "group_analysis_matrices.js", "new_cycle.js",
      "ics234_pdf.js", "users.js", "company_autocomplete.js",
      "analysis_matrix_published.js",
      "cycles/new_cycle.css", "cycles/form.css", "cycles/formpdf.css",
      "cycles.css",
      "search_users.js", "company_autocomplete.css",
      "analysis_matrices/formpdf.css", "analysis_matrices/group_approval.css",
      "analysis_matrices.css",
      "analysis_matrices_expression_colors.css",
      "analysis_matrices_published_expression_colors.css",
      "search_users.css",
      "user_form.css"
    ]
  end
end
