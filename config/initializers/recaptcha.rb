Recaptcha.configure do |config|
  config.site_key  = CONFIG.RECAPTCHA_SITE_KEY
  config.secret_key = CONFIG.RECAPTCHA_SECRET_KEY
end