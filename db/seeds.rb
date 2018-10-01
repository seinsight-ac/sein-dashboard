# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: "test@example.com", password: "12345678")

# fb
FbDb.destroy_all

def set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click, i)
  while i < fan.length
    api_date = fan[i]["end_time"].to_date

    fb = FbDb.new
    fb.date = api_date
    fb.fans = fan[i]["value"]

    if !fan_add[0]["values"][i].nil? && fan_add[0]["values"][i]["end_time"].to_date == api_date
      fb.fans_adds_day = fan_add[0]["values"][i]["value"]
      fb.fans_adds_week = fan_add[1]["values"][i]["value"]
      fb.fans_adds_month = fan_add[2]["values"][i]["value"]
    else 
      puts "didn't have fan_add date"
    end

    if !fan_lost[0]["values"][i].nil? && fan_lost[0]["values"][i]["end_time"].to_date == api_date
      fb.fans_losts_day = fan_lost[0]["values"][i]["value"]
      fb.fans_losts_week = fan_lost[1]["values"][i]["value"]
      fb.fans_losts_month = fan_lost[2]["values"][i]["value"]
    else 
      puts "didn't have fans_lost data"
    end

    if !page[0]["values"][i].nil? && page[0]["values"][i]["end_time"].to_date == api_date
      fb.page_users_day = page[0]["values"][i]["value"]
      fb.page_users_week = page[1]["values"][i]["value"]
      fb.page_users_month = page[2]["values"][i]["value"]
    else
      puts "didn't have page data"
    end

    if !post[0]["values"][i].nil? && post[0]["values"][i]["end_time"].to_date == api_date
      fb.posts_users_day = post[0]["values"][i]["value"]
      fb.posts_users_week = post[1]["values"][i]["value"]
      fb.posts_users_month = post[2]["values"][i]["value"]
    else
      puts "didn't have post data"
    end

    if !post_enagement[0]["values"][i].nil? && post_enagement[0]["values"][i]["end_time"].to_date == api_date
      fb.post_enagements_day = post_enagement[0]["values"][i]["value"]
      fb.post_enagements_week = post_enagement[1]["values"][i]["value"]
      fb.post_enagements_month = post_enagement[2]["values"][i]["value"]
    else
      puts "didn't have post_enagement data"
    end

    if !negative[0]["values"][i].nil? && negative[0]["values"][i]["end_time"].to_date == api_date
      fb.negative_users_day = negative[0]["values"][i]["value"]
      fb.negative_users_week = negative[1]["values"][i]["value"]
      fb.negative_users_month = negative[2]["values"][i]["value"]
    else
      puts "didn't have negative data"
    end

    if !link_click[0]["values"][i].nil? && link_click[0]["values"][i]["end_time"].to_date == api_date
      fb.link_clicks_day = link_click[0]["values"][i]["value"]["link clicks"]
      fb.link_clicks_week = link_click[1]["values"][i]["value"]["link clicks"]
      fb.link_clicks_month = link_click[2]["values"][i]["value"]["link clicks"]
    else
      puts "didn't have link click data"
    end

    if !gender.nil? && !gender[0]["values"].nil? && !gender[0]["values"][i].nil? && gender[0]["values"][i]["end_time"].to_date == api_date
      fb.fans_female_day = gender[0]["values"][i]["value"].values[0..6].inject(0, :+)
      fb.fans_male_day = gender[0]["values"][i]["value"].values[7..13].inject(0, :+)
      fb.fans_13_17 = gender[0]["values"][i]["value"].values[0, 7].inject(0, :+)
      fb.fans_18_24 = gender[0]["values"][i]["value"].values[1, 8].inject(0, :+)
      fb.fans_25_34 = gender[0]["values"][i]["value"].values[2, 9].inject(0, :+)
      fb.fans_35_44 = gender[0]["values"][i]["value"].values[3, 10].inject(0, :+)
      fb.fans_45_54 = gender[0]["values"][i]["value"].values[4, 11].inject(0, :+)
      fb.fans_55_64 = gender[0]["values"][i]["value"].values[5, 12].inject(0, :+)
      fb.fans_65 = gender[0]["values"][i]["value"].values[6, 13].inject(0, :+)
    else
      puts "didn't have gender data"
    end

    if !enagement[0]["values"][i].nil? && enagement[0]["values"][i]["end_time"].to_date == api_date
      fb.enagements_users_day = enagement[0]["values"][i]["value"]
      fb.enagements_users_week = enagement[1]["values"][i]["value"]
      fb.enagements_users_month = enagement[2]["values"][i]["value"]
    else
      puts "didn't have enagements data"
    end
    fb.save!
    i += 1
  end
end

@fb = Koala::Facebook::API.new(CONFIG.FB_TOKEN)

def get_year_data(what)
  years_ago = (Date.today << 12).to_s

  @fb.get_object("278666028863859/insights/#{what}?fields=values&since=#{years_ago}")
end

def get_3_days_data(what)
  @fb.get_object("278666028863859/insights/#{what}?fields=values&date_preset=last_3_days")
end

fan = get_year_data("page_fans").first.first.second
fan_add = get_year_data("page_fan_adds_unique")
fan_lost = get_year_data("page_fan_removes_unique")
page = get_year_data("page_impressions_unique")
post = get_year_data("page_posts_impressions_unique")
enagement = get_year_data("page_engaged_users")
negative = get_year_data("page_negative_feedback_unique")
gender = get_year_data("page_fans_gender_age")
post_enagement = get_year_data("page_post_engagements")
link_click = get_year_data("page_consumptions_by_consumption_type")

set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click, 0)

fan = get_3_days_data("page_fans").first.first.second
fan_add = get_3_days_data("page_fan_adds_unique")
fan_lost = get_3_days_data("page_fan_removes_unique")
page = get_3_days_data("page_impressions_unique")
post = get_3_days_data("page_posts_impressions_unique")
enagement = get_3_days_data("page_engaged_users")
negative = get_3_days_data("page_negative_feedback_unique")
post_enagement = get_3_days_data("page_post_engagements")
link_click = get_3_days_data("page_consumptions_by_consumption_type")
gender = get_3_days_data("page_fans_gender_age")

i = 0

while FbDb.last.date >= fan[i]["end_time"]
  i += 1
end

set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click, i)

puts "create #{FbDb.count} fb data"

# ga

GaDb.destroy_all

def set_ga_db(user, user_7, user_30, session_pageview, 
  bounce, pageview, session, channel, avg_session, avg_time_page, 
  bracket, gender, page_per_session, device, user_type, single)
  i = 0
  b = 0
  c = 0
  d = 0
  e = 0

  while i < user.size
    date = user[i]["dimensions"][0]

    ga = GaDb.new
    ga.date = user[i]["dimensions"][0]
    ga.web_users_day = user[i]["metrics"][0]["values"][0].to_f

    if !user_7.nil? && user_7[i]["dimensions"][0] == date
      ga.web_users_week = user_7[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have user_7 data"
    end

    if !user_30.nil? && user_30[i]["dimensions"][0] == date
      ga.web_users_month = user_30[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have user_30 data"
    end

    if !session_pageview.nil? && session_pageview[i]["dimensions"][0] == date
      ga.session_pageviews_day = session_pageview[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have session_pageview data"
    end

    if !session.nil? && session[i]["dimensions"][0] == date
      ga.sessions_day = session[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have sessions_day data"
    end

    if !bounce.nil? && bounce[i]["dimensions"][0] == date
      ga.bouce_rate_day = bounce[i]["metrics"][0]["values"][0].to_f
    else 
      puts "didn't have bounce data"
    end

    if !pageview.nil? && pageview[i]["dimensions"][0] == date
      ga.pageviews_day = pageview[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have pageviews day"
    end

    if !avg_session.nil? && avg_session[i]["dimensions"][0] == date
      ga.avg_session_duration_day = avg_session[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have avg_session data"
    end

    if !avg_time_page.nil? && avg_time_page[i]["dimensions"][0] == date
      ga.avg_time_on_page_day = avg_time_page[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have avg_time data"
    end

    if !page_per_session.nil? && page_per_session[i]["dimensions"][0] == date
      ga.pageviews_per_session_day = page_per_session[i]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have page_per data"
    end

    if !device.nil? && device[b]["dimensions"][0] == date
      ga.desktop_user = device[b]["metrics"][0]["values"][0].to_f
      ga.mobile_user = device[b]["metrics"][0]["values"][0].to_f
      ga.tablet_user = device[b + 2]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have device data"
    end

    if !user_type.nil? && user_type[d]["dimensions"][0] == date
      ga.new_visitor = user_type[d]["metrics"][0]["values"][0].to_f
      ga.return_visitor = user_type[d + 1]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have user_type data"
    end

    if !gender.nil? && gender[d]["dimensions"][0] == date
      ga.female_user = gender[d]["metrics"][0]["values"][0].to_f
      ga.male_user = gender[d + 1]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have gender data"
    end

    if !bracket.nil? && bracket[e]["dimensions"][0] == date
      ga.user_18_24 = bracket[e]["metrics"][0]["values"][0].to_f
      ga.user_25_34 = bracket[e + 1]["metrics"][0]["values"][0].to_f
      ga.user_35_44 = bracket[e + 2]["metrics"][0]["values"][0].to_f
      ga.user_45_54 = bracket[e + 3]["metrics"][0]["values"][0].to_f
      ga.user_55_64 = bracket[e + 4]["metrics"][0]["values"][0].to_f
      ga.user_65 = bracket[e + 5]["metrics"][0]["values"][0].to_f
    else
      puts "didn't have bracket data"
    end

    if channel[c]["dimensions"][1] == "Direct" 
      ga.direct_user_day = channel[c]["metrics"][0]["values"][0].to_f
      ga.direct_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    elsif channel[c]["dimensions"][1] == "(Other)"
      c += 1
      ga.direct_user_day = channel[c]["metrics"][0]["values"][0].to_f
      ga.direct_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    end

    if channel[c]["dimensions"][1] == "Email" 
      ga.email_user_day = channel[c]["metrics"][0]["values"][0].to_f 
      ga.email_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    elsif channel[c]["dimensions"][1] == "Display"
      c += 1
      if channel[c]["dimensions"][1] == "Email" 
        ga.email_user_day = channel[c]["metrics"][0]["values"][0].to_f 
        ga.email_bounce = channel[c]["metrics"][0]["values"][1].to_f
        c += 1
      end
    end
        
    if channel[c]["dimensions"][1] == "Organic Search"
      ga.oganic_search_day = channel[c]["metrics"][0]["values"][0].to_f
      ga.oganic_search_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    end

    if channel[c]["dimensions"][1] == "Referral"
      ga.referral_user_day = channel[c]["metrics"][0]["values"][0].to_f
      ga.referral_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    end

    if channel[c]["dimensions"][1] == "Social" 
      ga.social_user_day = channel[c]["metrics"][0]["values"][0].to_f
      ga.social_bounce = channel[c]["metrics"][0]["values"][1].to_f
      c += 1
    end

    ga.single_session = single[i]["metrics"][0]["values"][0].to_f
    ga.save!

    b += 3
    e += 6
    d += 2
    c += 1
    i += 1

  end
end

years_ago = (Date.today << 12).to_s
today = (Date.today - 1).to_s

ga = GoogleAnalytics.new(years_ago, today)

user = ga.users
user_7 = ga.users_7
user_30 = ga.users_30
session_pageview = ga.page_per_session
bounce = ga.bounce
pageview = ga.pageview
session = ga.session
user_type = ga.user_type
channel = ga.channel + ga.channel(1000)
avg_session = ga.avg_session
avg_time_page = ga.avg_time_page
bracket = ga.bracket + ga.bracket(1000) + ga.bracket(2000)
gender = ga.gender
page_per_session = ga.page_per_session
device = ga.device + ga.device(1000)
single = ga.session_pageviews

set_ga_db(user, user_7, user_30, session_pageview, bounce, 
  pageview, session, channel, avg_session, avg_time_page, 
  bracket, gender, page_per_session, device, user_type, single)

puts "create #{GaDb.count} ga data"

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
