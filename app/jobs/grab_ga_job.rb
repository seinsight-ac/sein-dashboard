class GrabGaJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = GaDb.count

    day_3 = (Date.today - 1).to_s
    today = (Date.today - 1).to_s

    ga = GoogleAnalytics.new(day_3, today)

    @user = ga.users
    @user_7 = ga.users_7
    @user_30 = ga.users_30
    @session_pageview = ga.page_per_session
    @bounce = ga.bounce
    @pageview = ga.pageview
    @session = ga.session
    @user_type = ga.user_type
    @channel = ga.channel
    @avg_session = ga.avg_session
    @avg_time_page = ga.avg_time_page
    @bracket = ga.bracket
    @gender = ga.gender
    @page_per_session = ga.page_per_session
    @device = ga.device
    @single = ga.session_pageviews

    set_ga_db

    puts "add #{GaDb.count - count} ga data"
  end

  def set_ga_db
    i = 0
    b = 0
    c = 0
    d = 0
    e = 0

    while i < @user.size
      date = @user[i]["dimensions"][0]
      if GaDb.last.date > date
        puts "error execute seed first"
      elsif GaDb.last.date == date
      else
        if @user_7[i]["dimensions"][0] != date
          puts "user_7"
          puts date
          puts @user_7[i]["dimensions"][0]
          break
        elsif @session_pageview[i]["dimensions"][0] != date
          puts "session pageview"
          puts date
          puts @session_pageview[i]["dimensions"][0]
          break
        elsif @bounce[i]["dimensions"][0] != date
          puts "bounce"
          puts date
          puts @bounce[i]["dimensions"][0]
          break
        elsif @pageview[i]["dimensions"][0] != date
          puts "pageview"
          puts date
          puts @pageview[i]["dimensions"][0]
          break
        elsif @session[i]["dimensions"][0] != date
          puts "session"
          puts date
          puts @session[i]["dimensions"][0]
          break
        elsif @channel[c]["dimensions"][0] != date
          puts "channel"
          puts date
          puts @channel[c]["dimensions"][0]
          break
        elsif @bracket[e]["dimensions"][0] != date
          puts "bracket"
          puts date
          puts @bracket[e]["dimensions"][0]
          break
        elsif @avg_session[i]["dimensions"][0] != date
          puts "avg_session"
          puts date
          puts @avg_session[i]["dimensions"][0]
          break
        elsif @avg_time_page[i]["dimensions"][0] != date
          puts "avg_time_page"
          puts date
          puts @avg_time_page[i]["dimensions"][0]
          break
        elsif @page_per_session[i]["dimensions"][0] != date
          puts "page_per_session"
          puts date
          puts @page_per_session[i]["dimensions"][0]
          break
        elsif @single[i]["dimensions"][1] != date
          puts "page_per_session"
          puts date
          puts @page_per_session[i]["dimensions"][0]
          break
        elsif @gender[d]["dimensions"][0] != date
          puts "gender"
          puts date
          puts @gender[d]["dimensions"][0]
          break
        elsif @user_type[d]["dimensions"][0] != date
          puts "user_typ"
          puts date
          puts @user_typ[d]["dimensions"][0]
          break
        elsif @device[b]["dimensions"][0] != date
          puts "device"
          puts date
          puts @device[b]["dimensions"][0]
          break
        else
          GaDb.create(
          date: @user[i]["dimensions"][0],
          web_users_day: @user[i]["metrics"][0]["values"][0].to_f,
          web_users_week: @user_7[i]["metrics"][0]["values"][0].to_f,
          web_users_month: @user_30[i]["metrics"][0]["values"][0].to_f,
          session_pageviews_day: @session_pageview[i]["metrics"][0]["values"][0].to_f,
          sessions_day: @session[i]["metrics"][0]["values"][0].to_f,
          bouce_rate_day: @bounce[i]["metrics"][0]["values"][0].to_f,
          pageviews_day: @pageview[i]["metrics"][0]["values"][0].to_f,
          avg_session_duration_day: @avg_session[i]["metrics"][0]["values"][0].to_f,
          avg_time_on_page_day: @avg_time_page[i]["metrics"][0]["values"][0].to_f,
          pageviews_per_session_day: @page_per_session[i]["metrics"][0]["values"][0].to_f,
          desktop_user: @device[b]["metrics"][0]["values"][0].to_f,
          mobile_user: @device[b + 1]["metrics"][0]["values"][0].to_f,
          tablet_user: @device[b + 2]["metrics"][0]["values"][0].to_f,
          new_visitor: @user_type[d]["metrics"][0]["values"][0].to_f,
          return_visitor: @user_type[d + 1]["metrics"][0]["values"][0].to_f,
          female_user: @gender[d]["metrics"][0]["values"][0].to_f,
          male_user: @gender[d + 1]["metrics"][0]["values"][0].to_f,
          user_18_24: @bracket[e]["metrics"][0]["values"][0].to_f,
          user_25_34: @bracket[e + 1]["metrics"][0]["values"][0].to_f,
          user_35_44: @bracket[e + 2]["metrics"][0]["values"][0].to_f,
          user_45_54: @bracket[e + 3]["metrics"][0]["values"][0].to_f,
          user_55_64: @bracket[e + 4]["metrics"][0]["values"][0].to_f,
          user_65: @bracket[e + 5]["metrics"][0]["values"][0].to_f,
          direct_user_day: 
          if @channel[c]["dimensions"][1] == "Direct" 
            t = c
            c += 1
            @channel[c - 1]["metrics"][0]["values"][0].to_f
          elsif @channel[c]["dimensions"][1] == "(Other)"
            t = c + 1
            c += 2
            @channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          direct_bounce: 
          if @channel[t]["dimensions"][1] == "Direct" 
            @channel[t]["metrics"][0]["values"][1].to_f
          end,
          email_user_day: 
          if @channel[c]["dimensions"][1] == "Email" 
            t = c
            c += 1
            @channel[c - 1]["metrics"][0]["values"][0].to_f
          elsif channel[c]["dimensions"][1] == "Display"
            c += 1
            if @channel[c]["dimensions"][1] == "Email" 
              t = c
              c += 1
              @channel[c - 1]["metrics"][0]["values"][0].to_f
            end
          end,
          email_bounce: 
          if @channel[t]["dimensions"][1] == "Email" 
            @channel[t]["metrics"][0]["values"][1].to_f
          end,
          oganic_search_day: 
          if @channel[c]["dimensions"][1] == "Organic Search" 
            t = c
            c += 1
            @channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          oganic_search_bounce: 
          if @channel[t]["dimensions"][1] == "Organic Search" 
            @channel[t]["metrics"][0]["values"][1].to_f
          end,
          referral_user_day: 
          if @channel[c]["dimensions"][1] == "Referral" 
            t = c
            c += 1
            channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          referral_bounce: 
          if @channel[t]["dimensions"][1] == "Referral" 
            @channel[t]["metrics"][0]["values"][1].to_f
          end,
          social_user_day:
          if @channel[c]["dimensions"][1] == "Social" 
            t = c
            c += 1
            @channel[c - 1]["metrics"][0]["values"][0].to_f
          end,
          social_bounce: 
          if @channel[t]["dimensions"][1] == "Social" 
            @channel[t]["metrics"][0]["values"][1].to_f
          end,

          single_session: @single[i]["metrics"][0]["values"][0].to_f
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
end
