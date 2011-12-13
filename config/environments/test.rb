HeyPalBackEnd::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Local Redis Configuration
  ENV["REDISTOGO_URL"] = 'redis://mopx:aaf3ce5564ab359b8695223b53a50002@stingfish.redistogo.com:9181'
  #ENV["REDISTOGO_URL"] = 'redis://127.0.0.1:6379'
  
  # Facebook authentications
  FB = {
    :app_id     => '221413484589066', 
    :app_secret => '719daf903365b4bab445a2ef5c54c2ea', 
    :app_url    => 'https://graph.facebook.com'
  }

  # Memcache configuration
  config.cache_store = :dalli_store, 'localhost:11211', { :namespace => "heypal", :expires_in => 1.minute, :compress => false }
  
end
