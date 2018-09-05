require 'json'

class Mailchimp

  def self.campaigns(since, before)
    campaigns = RestClient::Request.execute(method: :get, 
      url: "#{CONFIG.MAILCHIMP_URL}/campaigns",
      user: 'anystring', 
      password: CONFIG.MAILCHIMP_KEY,
      headers: {params: {
        since_send_time: '2018-08-01T00:00:00+00:00',
        before_send_time: '2018-09-01T00:00:00+00:00',
        sort_field: 'send_time',
        sort_dir: 'ASC',
        status: 'sent'}})
    campaigns = JSON.parse(campaigns)
    campaigns["campaigns"]
  end


  def self.click_details(id)
    links = RestClient::Request.execute(method: :get, 
      url: "#{CONFIG.MAILCHIMP_URL}/reports/#{id}/click-details", 
      user: 'anystring', 
      password: CONFIG.MAILCHIMP_KEY)
    links = JSON.parse(links)
    max = 0
    max_link = {}
    links["urls_clicked"].each do |link|
      if link["unique_clicks"] > max
        max = link["unique_clicks"]
        max_link = link
      end
    end

    return max_link
  end

end
