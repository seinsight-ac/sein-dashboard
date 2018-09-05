require 'gibbon'
require 'json'

class Mailchimp

  def self.mailchimp_campaign
    @mailchimp = Gibbon::Request.new(api_key: CONFIG.MAILCHIMP_KEY)
    @mailchimp.timeout = 30
    @mailchimp.open_timeout = 30
    campaigns = @mailchimp.campaigns.retrieve
    JSON.parse(campaigns.to_json)
  end

  def self.mailchimp_report_open(id)
    open = @mailchimp.reports(id).retrieve["opens"]
  end

  def self.mailchimp_report_click(id)
    click = @mailchimp.reports(id).retrieve["clicks"]
  end
  
end
