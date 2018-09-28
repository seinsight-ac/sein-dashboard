class GrabAlexaJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = AlexaDb.count

    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")

    def rank(data)
      data[1].inner_text.delete(',').to_i
    end

    def convert_rate(data)
      data[2].inner_text.to_i / 100.to_f
    end

    def pageview(data)
      data[3].inner_text.to_f
    end

    def site(data)
      data[4].inner_text.to_i * 60 + @sein[4].inner_text[3..4].to_i
    end

    AlexaDb.create(
      sein_rank: rank(@sein),
      newsmarket_rank: rank(@newsmarket),
      pansci_rank: rank(@pansci), 
      einfo_rank: rank(@einfo),
      npost_rank: rank(@npost),
      womany_rank: rank(@womany),
      sein_bounce_rate: convert_rate(@sein),
      newsmarket_bounce_rate: convert_rate(@newsmarket),
      pansci_bounce_rate: convert_rate(@pansci), 
      einfo_bounce_rate: convert_rate(@einfo),
      npost_bounce_rate: convert_rate(@npost),
      womany_bounce_rate: convert_rate(@womany),
      sein_pageview: pageview(@sein),
      newsmarket_pageview: pageview(@newsmarket),
      pansci_pageview: pageview(@pansci), 
      einfo_pageview: pageview(@einfo),
      npost_pageview: pageview(@npost),
      womany_pageview: pageview(@womany),
      sein_on_site: site(@sein),
      newsmarket_on_site: site(@newsmarket),
      pansci_on_site: site(@pansci), 
      einfo_on_site: site(@einfo),
      npost_on_site: site(@npost),
      womany_on_site: site(@womany)
    )

    puts "add #{AlexaDb.count - count} alexa data"
  end
end
