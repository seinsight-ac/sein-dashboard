require 'gibbon'

def get_mailchimp_report
  mailchimp = Gibbon::Request.new(api_key: CONFIG.MAILCHIMP_KEY)
  mailchimp.timeout = 30
  mailchimp.open_timeout = 30
  result = mailchimp.campaigns.retrieve
end