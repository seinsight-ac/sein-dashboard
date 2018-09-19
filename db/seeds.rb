# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: "test@example.com", password: "12345678")


# mailchimp
MailchimpDb.destroy_all

def set_mailchimp_db(campaigns)
  campaigns.each do |c|
    link = Mailchimp.click_details(c["id"])
    MailchimpDb.create(
      date: c["send_time"], 
      title: c["settings"]["subject_line"],
      email_sent: c["emails_sent"],
      open: c["report_summary"]["opens"],
      open_rate: c["report_summary"]["open_rate"],
      click: c["report_summary"]["subscriber_clicks"],
      click_rate: c["report_summary"]["click_rate"],
      most_click_title: link["url"],
      most_click_time: link["unique_clicks"]
      )
  end
end

before = (Date.today - 2) << 11
since = (Date.today - 2) << 12

campaigns = Mailchimp.campaigns(since.to_s, before.to_s)
campaigns.reverse!
set_mailchimp_db(campaigns)

11.times do

  before = before >> 1
  since = since >> 1

  campaigns = Mailchimp.campaigns(since.to_s, before.to_s)
  campaigns.reverse!
  set_mailchimp_db(campaigns)
end

puts "create #{MailchimpDb.count} mailchimp data"

# alexa
AlexaDb.destroy_all

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
  data[2].inner_text.to_f / 100
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

puts "create #{AlexaDb.count} alexa data"
