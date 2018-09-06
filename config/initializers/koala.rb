# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.app_id = CONFIG.FB_APP_ID
  config.app_secret = CONFIG.FB_SECRET
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end