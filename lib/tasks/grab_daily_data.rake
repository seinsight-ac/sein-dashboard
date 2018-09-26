task grab_fb_data: :environment do 
  count = FbDb.count

  def set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click)
    i = 0

    while i < fan.length
      if FbDb.last.date > fan[i]["end_time"]
      elsif gender[0]["values"][i] != nil && FbDb.last.date == gender[0]["values"][i]["end_time"]
        old = FbDb.last
        old.fans_female_day = gender[0]["values"][i]["value"].values[0..6].inject(0, :+)
        old.fans_male_day = gender[0]["values"][i]["value"].values[7..13].inject(0, :+)
        old.fans_13_17 = gender[0]["values"][i]["value"].values[0, 7].inject(0, :+)
        old.fans_18_24 = gender[0]["values"][i]["value"].values[1, 8].inject(0, :+)
        old.fans_25_34 = gender[0]["values"][i]["value"].values[2, 9].inject(0, :+)
        old.fans_35_44 = gender[0]["values"][i]["value"].values[3, 10].inject(0, :+)
        old.fans_45_54 = gender[0]["values"][i]["value"].values[4, 11].inject(0, :+)
        old.fans_55_64 = gender[0]["values"][i]["value"].values[5, 12].inject(0, :+)
        old.fans_65 = gender[0]["values"][i]["value"].values[6, 13].inject(0, :+)
        old.save!
      elsif FbDb.last.date == fan[i]["end_time"]
      elsif fan[i]["end_time"].to_date.strftime("%Y%m%d") == Date.today.strftime("%Y%m%d")
      else
        date = fan[i]["end_time"]
        puts date
        if fan_add[0]["values"][i]["end_time"] != date
          puts "fan_add"
          puts date
          puts fan_add[0]["values"][i]["end_time"]
          break
        elsif fan_lost[0]["values"][i]["end_time"] != date 
          puts "fan_lost"
          puts date
          puts fan_lost[0]["values"][i]["end_time"]
          break
        elsif page[0]["values"][i]["end_time"] != date 
          puts "page"
          puts date
          puts page[0]["values"][i]["end_time"]
          break
        elsif post[0]["values"][i]["end_time"] != date 
          puts "post"
          puts date
          puts post[0]["values"][i]["end_time"]
          break
        elsif enagement[0]["values"][i]["end_time"] != date 
          puts "enagement"
          puts date
          puts enagement[0]["values"][i]["end_time"]
          break
        elsif negative[0]["values"][i]["end_time"] != date 
          puts "negative"
          puts date
          puts negative[0]["values"][i]["end_time"]
          break
        elsif post_enagement[0]["values"][i]["end_time"] != date 
          puts "fan_lost"
          puts date
          puts post_enagement[0]["values"][i]["end_time"]
          break
        elsif link_click[0]["values"][i]["end_time"] != date 
          puts "link_click"
          puts date
          puts link_click[0]["values"][i]["end_time"]
          break
        elsif gender[0]["values"][i] == nil
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
            enagements_users_day: enagement[0]["values"][i]["value"],
            enagements_users_week: enagement[1]["values"][i]["value"],
            enagements_users_month: enagement[2]["values"][i]["value"]
            )
          i += 1
        elsif gender[0]["values"][i]["end_time"] != date
          puts "gender"
          puts date
          puts gender[0]["values"][i]["end_time"]
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
            fans_female_day: gender[0]["values"][i]["value"].values[0..6].inject(0, :+),
            fans_male_day: gender[0]["values"][i]["value"].values[7..13].inject(0, :+),
            fans_13_17: gender[0]["values"][i]["value"].values[0, 7].inject(0, :+),
            fans_18_24: gender[0]["values"][i]["value"].values[1, 8].inject(0, :+),
            fans_25_34: gender[0]["values"][i]["value"].values[2, 9].inject(0, :+),
            fans_35_44: gender[0]["values"][i]["value"].values[3, 10].inject(0, :+),
            fans_45_54: gender[0]["values"][i]["value"].values[4, 11].inject(0, :+),
            fans_55_64: gender[0]["values"][i]["value"].values[5, 12].inject(0, :+),
            fans_65: gender[0]["values"][i]["value"].values[6, 13].inject(0, :+),
            enagements_users_day: enagement[0]["values"][i]["value"],
            enagements_users_week: enagement[1]["values"][i]["value"],
            enagements_users_month: enagement[2]["values"][i]["value"]
            )
        end
      end
      i += 1
    end
  end

  @fb = Koala::Facebook::API.new(CONFIG.FB_TOKEN)

  def get_3_days_data(what)
    @fb.get_object("278666028863859/insights/#{what}?fields=values&date_preset=last_3_days")
  end

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


  set_fb_db(fan, fan_add, page, post, enagement, negative, gender, fan_lost, post_enagement, link_click)

  puts "add #{FbDb.count - count} fb data"
end

task grab_ga_data: :environment do
  count = GaDb.count

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
      if GaDb.last.date > date
        puts "error execute seed first"
      elsif GaDb.last.date == date
      else
        if user_7[i]["dimensions"][0] != date
          puts "user_7"
          puts date
          puts user_7[i]["dimensions"][0]
          break
        elsif session_pageview[i]["dimensions"][0] != date
          puts "session pageview"
          puts date
          puts session_pageview[i]["dimensions"][0]
          break
        elsif bounce[i]["dimensions"][0] != date
          puts "bounce"
          puts date
          puts bounce[i]["dimensions"][0]
          break
        elsif pageview[i]["dimensions"][0] != date
          puts "pageview"
          puts date
          puts pageview[i]["dimensions"][0]
          break
        elsif session[i]["dimensions"][0] != date
          puts "session"
          puts date
          puts session[i]["dimensions"][0]
          break
        elsif channel[c]["dimensions"][0] != date
          puts "channel"
          puts date
          puts channel[c]["dimensions"][0]
          break
        elsif bracket[e]["dimensions"][0] != date
          puts "bracket"
          puts date
          puts bracket[e]["dimensions"][0]
          break
        elsif avg_session[i]["dimensions"][0] != date
          puts "avg_session"
          puts date
          puts avg_session[i]["dimensions"][0]
          break
        elsif avg_time_page[i]["dimensions"][0] != date
          puts "avg_time_page"
          puts date
          puts avg_time_page[i]["dimensions"][0]
          break
        elsif page_per_session[i]["dimensions"][0] != date
          puts "page_per_session"
          puts date
          puts page_per_session[i]["dimensions"][0]
          break
        elsif single[i]["dimensions"][1] != date
          puts "page_per_session"
          puts date
          puts page_per_session[i]["dimensions"][0]
          break
        elsif gender[d]["dimensions"][0] != date
          puts "gender"
          puts date
          puts gender[d]["dimensions"][0]
          break
        elsif user_type[d]["dimensions"][0] != date
          puts "user_typ"
          puts date
          puts user_typ[d]["dimensions"][0]
          break
        elsif device[b]["dimensions"][0] != date
          puts "device"
          puts date
          puts device[b]["dimensions"][0]
          break
        else
          GaDb.create(
          date: user[i]["dimensions"][0],
          web_users_day: user[i]["metrics"][0]["values"][0].to_f,
          web_users_week: user_7[i]["metrics"][0]["values"][0].to_f,
          web_users_month: user_30[i]["metrics"][0]["values"][0].to_f,
          session_pageviews_day: session_pageview[i]["metrics"][0]["values"][0].to_f,
          sessions_day: session[i]["metrics"][0]["values"][0].to_f,
          bouce_rate_day: bounce[i]["metrics"][0]["values"][0].to_f,
          pageviews_day: pageview[i]["metrics"][0]["values"][0].to_f,
          avg_session_duration_day: avg_session[i]["metrics"][0]["values"][0].to_f,
          avg_time_on_page_day: avg_time_page[i]["metrics"][0]["values"][0].to_f,
          pageviews_per_session_day: page_per_session[i]["metrics"][0]["values"][0].to_f,
          desktop_user: device[b]["metrics"][0]["values"][0].to_f,
          mobile_user: device[b + 1]["metrics"][0]["values"][0].to_f,
          tablet_user: device[b + 2]["metrics"][0]["values"][0].to_f,
          new_visitor: user_type[d]["metrics"][0]["values"][0].to_f,
          return_visitor: user_type[d + 1]["metrics"][0]["values"][0].to_f,
          female_user: gender[d]["metrics"][0]["values"][0].to_f,
          male_user: gender[d + 1]["metrics"][0]["values"][0].to_f,
          user_18_24: bracket[e]["metrics"][0]["values"][0].to_f,
          user_25_34: bracket[e + 1]["metrics"][0]["values"][0].to_f,
          user_35_44: bracket[e + 2]["metrics"][0]["values"][0].to_f,
          user_45_54: bracket[e + 3]["metrics"][0]["values"][0].to_f,
          user_55_64: bracket[e + 4]["metrics"][0]["values"][0].to_f,
          user_65: bracket[e + 5]["metrics"][0]["values"][0].to_f,
          direct_user_day: 
          if channel[c]["dimensions"][1] == "Direct" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          elsif channel[c]["dimensions"][1] == "(Other)"
            t = c + 1
            c += 2
            channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          direct_bounce: 
          if channel[t]["dimensions"][1] == "Direct" 
            channel[t]["metrics"][0]["values"][1].to_f
          end,
          email_user_day: 
          if channel[c]["dimensions"][1] == "Email" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          elsif channel[c]["dimensions"][1] == "Display"
            c += 1
            if channel[c]["dimensions"][1] == "Email" 
              t = c
              c += 1
              channel[c - 1]["metrics"][0]["values"][0].to_f
            end
          end,
          email_bounce: 
          if channel[t]["dimensions"][1] == "Email" 
            channel[t]["metrics"][0]["values"][1].to_f
          end,
          oganic_search_day: 
          if channel[c]["dimensions"][1] == "Organic Search" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          oganic_search_bounce: 
          if channel[t]["dimensions"][1] == "Organic Search" 
            channel[t]["metrics"][0]["values"][1].to_f
          end,
          referral_user_day: 
          if channel[c]["dimensions"][1] == "Referral" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          referral_bounce: 
          if channel[t]["dimensions"][1] == "Referral" 
            channel[t]["metrics"][0]["values"][1].to_f
          end,
          social_user_day:
          if channel[c]["dimensions"][1] == "Social" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          social_bounce: 
          if channel[t]["dimensions"][1] == "Social" 
            channel[t]["metrics"][0]["values"][1].to_f
          end,

          single_session: single[i]["metrics"][0]["values"][0].to_f
          )
        end
        b += 3
        e += 6
        d += 2
        c += 1
      end

      i += 1

    end
  end

  day_3 = (Date.today - 1).to_s
  today = (Date.today - 1).to_s

  ga = GoogleAnalytics.new(day_3, today)

  user = ga.users
  user_7 = ga.users_7
  user_30 = ga.users_30
  session_pageview = ga.page_per_session
  bounce = ga.bounce
  pageview = ga.pageview
  session = ga.session
  user_type = ga.user_type
  channel = ga.channel
  avg_session = ga.avg_session
  avg_time_page = ga.avg_time_page
  bracket = ga.bracket
  gender = ga.gender
  page_per_session = ga.page_per_session
  device = ga.device
  single = ga.session_pageviews

  set_ga_db(user, user_7, user_30, session_pageview, bounce, 
    pageview, session, channel, avg_session, avg_time_page, 
    bracket, gender, page_per_session, device, user_type, single)

  puts "add #{GaDb.count - count} ga data"
end

task grab_mailchimp_data: :environment do
  count = MailchimpDb.count

  def set_mailchimp_db(campaigns)
    campaigns.each do |c|
      if c["send_time"].split('T').first != MailchimpDb.last.date.to_s.split(" ").first

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
  end

  before = (Date.today - 2)
  since = (Date.today - 7)

  campaigns = Mailchimp.campaigns(since.to_s, before.to_s)
  campaigns.reverse!
  set_mailchimp_db(campaigns)

  puts "add #{MailchimpDb.count - count} mailchimp data"

end

task grab_alexa_data: :environment do
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