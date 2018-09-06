require 'json'

class Similarweb

  def self.similars(since, before)
    @since = since
    @before = before
    similars = RestClient::Request.execute(method: :get, 
      url: "#{CONFIG.SIMILARWEB_URL}/seinsights.asia/search-competitors/organicsearchcompetitors",
      headers: {params: {
        api_key: CONFIG.SIMILARWEB_KEY,
        start_data: @since,
        end_data: @before,
        mail_doamin_only: true }})
    similars = JSON.parse(similars)
    similars["data"]
  end

  def self.visits(url)
    visits = RestClient::Request.execute(method: :get, 
      url: "#{CONFIG.SIMILARWEB_URL}/#{url}/total-traffic-and-engagement/visits",
      headers: {params: {
        api_key: CONFIG.SIMILARWEB_KEY,
        start_data: @since,
        end_data: @before,
        granularity: "weekly",
        mail_doamin_only: true }})
    visits = JSON.parse(visits)
    visits["visits"]
  end

end