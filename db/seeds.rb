# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: "test@example.com", password: "12345678")

=begin

# fb

FbDb.create(
  date: ,
  fans: ,
  fans_adds_day: ,
  fans_losts_day: ,
  page_users_day: ,
  posts_users_day: ,
  fans_adds_week: ,
  fans_losts_week: ,
  page_users_week: ,
  posts_users_week: ,
  fans_adds_month: ,
  fans_losts_month: ,
  page_users_month: ,
  posts_users_month: ,
  post_enagements_day: ,
  post_users_day: ,
  negative_activity_day: ,
  negative_users_day: ,
  post_enagements_week: ,
  post_users_week: ,
  negative_activity_week: ,
  negative_users_week: ,
  post_enagements_month: ,
  post_users_month: ,
  negative_activity_month: ,
  negative_users_month: ,
  link_clicks_day: ,
  link_clicks_week: ,
  link_clicks_month: ,
  fans_female_day: ,
  fans_male_day: ,
  fans_13_17: ,
  fans_18_24: ,
  fans_25_34: ,
  fans_35_44: ,
  fans_45_54: ,
  fans_55_64: ,
  fans_65: ,
  page_impressions_day: ,
  post_impressions_day: ,
  page_impressions_week: ,
  post_impressions_week: ,
  page_impressions_month: ,
  post_impressions_month: 
  )



# ga

GaDb.create(
  date: ,
  web_users_day: ,
  web_users_week: ,
  web_users_month: ,
  session_pageviews_day: ,
  session_pageviews_week: ,
  session_pageviews_month: ,
  users_day: ,
  users_week: ,
  users_month: ,
  sessions_day: ,
  sessions_week: ,
  sessions_month: ,
  active_users_day: ,
  active_users_week: ,
  active_users_month: ,
  bouce_rate_day: ,
  bouce_rate_week: ,
  bouce_rate_month: ,
  user_type_day: ,
  user_type_week: ,
  user_type_month: ,
  pageviews_day: ,
  pageviews_week: ,
  pageviews_month: ,
  avg_session_duration_day: ,
  avg_session_duration_week: ,
  avg_session_duration_month: ,
  avg_time_on_page_day: ,
  avg_time_on_page_week: ,
  avg_time_on_page_month: ,
  pageviews_per_session_day: ,
  pageviews_per_session_week: ,
  pageviews_per_session_month: ,
  desktop_user: ,
  mobile_user: ,
  tablet_user: ,
  female_user: ,
  male_user: ,
  user_18_24: ,
  user_25_34: ,
  user_35_44: ,
  user_45_54: ,
  user_55_64: ,
  user_65: ,
  session_count_day: ,
  session_count_week: ,
  session_count_month: ,
  referral_user_day: ,
  referral_user_week: ,
  referral_user_month: ,
  direct_user_day: ,
  direct_user_week: ,
  direct_user_month: ,
  social_user_day: ,
  social_user_week: ,
  social_user_month: ,
  email_user_day: ,
  email_user_week: ,
  email_user_month: ,
  oganic_search_day: ,
  oganic_search_week: ,
  oganic_search_month: 
  )

=end

=begin

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

=end