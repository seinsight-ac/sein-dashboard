require 'mechanize'

class Alexa

  def self.data(url)
    agent = Mechanize.new
    page = agent.get("https://www.alexa.com/siteinfo/#{url}")
    @text = page.search('strong.metrics-data')
  end

end