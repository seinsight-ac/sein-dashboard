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
FbDb.destroy_all

def set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click)
  i = 0

  while i < fan.length

    date = fan[i]["end_time"]
    if fan_add[0]["values"][i]["end_time"] != date
      puts "fan_add"
      puts date
      break
    elsif fan_lost[0]["values"][i]["end_time"] != date 
      puts "fan_lost"
      puts date
      break
    elsif page[0]["values"][i]["end_time"] != date 
      puts "page"
      puts date
      break
    elsif post[0]["values"][i]["end_time"] != date 
      puts "post"
      puts date
      break
    elsif enagement[0]["values"][i]["end_time"] != date 
      puts "enagement"
      puts date
      break
    elsif negative[0]["values"][i]["end_time"] != date 
      puts "negative"
      puts date
      break
    elsif post_enagement[0]["values"][i]["end_time"] != date 
      puts "fan_lost"
      puts date
      break
    elsif link_click[0]["values"][i]["end_time"] != date 
      puts "link_click"
      puts date
      break
    elsif gender[i]["end_time"] != date
      puts "gender"
      puts date
      break
    else
      FbDb.create(
        date: fan[i]["end_time"],
        fans: fan[i]["value"],
        fans_adds_day: fan_add[0]["values"][i]["value"],
        fans_losts_day: fan_lost[0]["values"][i]["value"],
        page_users_day: page[0]["values"][i]["value"],
        posts_users_day: post[0]["values"][i]["value"],
        fans_adds_week: fan_add[1]["values"][i]["value"],
        fans_losts_week: fan_lost[1]["values"][i]["value"],
        page_users_week: page[1]["values"][i]["value"],
        posts_users_week: post[1]["values"][i]["value"],
        fans_adds_month: fan_add[2]["values"][i]["value"],
        fans_losts_month: fan_lost[2]["values"][i]["value"],
        page_users_month: page[2]["values"][i]["value"],
        posts_users_month: post[2]["values"][i]["value"],
        post_enagements_day: post_enagement[0]["values"][i]["value"],
        negative_users_day: negative[0]["values"][i]["value"],
        post_enagements_week: post_enagement[1]["values"][i]["value"],
        negative_users_week: negative[1]["values"][i]["value"],
        post_enagements_month: post_enagement[2]["values"][i]["value"],
        negative_users_month: negative[2]["values"][i]["value"],
        link_clicks_day: link_click[0]["values"][i]["value"]["link clicks"],
        link_clicks_week: link_click[1]["values"][i]["value"]["link clicks"],
        link_clicks_month: link_click[2]["values"][i]["value"]["link clicks"],
        fans_female_day: gender[i]["value"].values[0..6].inject(0, :+),
        fans_male_day: gender[i]["value"].values[7..13].inject(0, :+),
        fans_13_17: gender[i]["value"].values[0, 7].inject(0, :+),
        fans_18_24: gender[i]["value"].values[1, 8].inject(0, :+),
        fans_25_34: gender[i]["value"].values[2, 9].inject(0, :+),
        fans_35_44: gender[i]["value"].values[3, 10].inject(0, :+),
        fans_45_54: gender[i]["value"].values[4, 11].inject(0, :+),
        fans_55_64: gender[i]["value"].values[5, 12].inject(0, :+),
        fans_65: gender[i]["value"].values[6, 13].inject(0, :+),
        enagements_users_day: enagement[0]["values"][i]["value"],
        enagements_users_week: enagement[1]["values"][i]["value"],
        enagements_users_month: enagement[2]["values"][i]["value"]
        )
    end

    i += 1

  end
end

years_ago = (Date.today << 12).to_s

fb = Koala::Facebook::API.new(CONFIG.FB_TOKEN)

fan = fb.get_object("278666028863859/insights/page_fans?fields=values&since=#{years_ago}").first.first.second
fan_add = fb.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&since=#{years_ago}")
fan_lost = fb.get_object("278666028863859/insights/page_fan_removes_unique?fields=values&since=#{years_ago}")
page = fb.get_object("278666028863859/insights/page_impressions_unique?fields=values&since=#{years_ago}")
post = fb.get_object("278666028863859/insights/page_posts_impressions_unique?fields=values&since=#{years_ago}")
enagement = fb.get_object("278666028863859/insights/page_engaged_users?fields=values&since=#{years_ago}")
negative = fb.get_object("278666028863859/insights/page_negative_feedback_unique?fields=values&since=#{years_ago}")
gender = fb.get_object("278666028863859/insights/page_fans_gender_age?fields=values&since=#{years_ago}").first.first.second
post_enagement = fb.get_object("278666028863859/insights/page_post_engagements?fields=values&since=#{years_ago}")
link_click = fb.get_object("278666028863859/insights/page_consumptions_by_consumption_type?fields=values&since=#{years_ago}")

set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click)

puts "create #{FbDb.count} fb data"

=end

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