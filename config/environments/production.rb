require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # Ensures that a master key has been made available.
  # config.require_master_key = true

  # Disable serving static files from `public/`.
  # config.public_file_server.enabled = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system.
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]
  # Action Cable configuration
  config.action_cable.url = ENV['ACTION_CABLE_URL']
  config.action_cable.allowed_request_origins = [
    ENV['FRONTEND_URL'],  # frontend
    ENV['BACKEND_URL']    # backend
  ]
  config.action_cable.disable_request_forgery_protection = true

  # Force all access to the app over SSL
  config.force_ssl = true

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # --- SENDGRID SETUP ---
  config.action_mailer.delivery_method = :test

  # Default mailer URLs (for Devise or notifications)
  config.action_mailer.default_url_options = { host: ENV['BACKEND_URL']&.gsub(/^https?:\/\//, ''), protocol: 'https' }
  config.action_mailer.default_options = { from: 'on2door@gmail.com' }

  config.i18n.fallbacks = true
  Rails.application.routes.default_url_options[:host] = ENV['BACKEND_URL']&.gsub(/^https?:\/\//, '')

  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end
