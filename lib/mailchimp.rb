require 'json'

class Mailchimp

  def self.campaigns(since, before)
    @data = RestClient::Request.execute(method: :get, 
      url: CONFIG.CAMPAIGNS_URL, 
      user: 'anystring', 
      password: CONFIG.MAILCHIMP_KEY,
      since_send_time: '#{since}T00:00:00+00:00',
      before_send_time: '#{before}T00:00:00+00:00',
      sort_field: 'send_time',
      sort_dir: 'ASC',
      status: 'sent')
  end

end
