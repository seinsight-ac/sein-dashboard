require 'json'

class Similarweb
  mattr_accessor :since
  mattr_accessor :before

  def initialize(since, before)
    self.since = since
    self.before = before
  end

  def data(url)
    data = RestClient::Request.execute(method: :get, 
      url: "#{CONFIG.SIMILARWEB_URL}#{url}/Geo/traffic-by-country",
      headers: {params: {
        api_key: CONFIG.SIMILARWEB_KEY,
        start_data: since,
        end_data: before,
        main_domain_only: false}})
    data = JSON.parse(data)
    data["records"]
  end

end