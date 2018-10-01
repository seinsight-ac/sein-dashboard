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
        i += 1
      elsif GaDb.last.date == date
        puts "already save"
        i += 1
      else
        ga = GaDb.new
        ga.date = @user[i]["dimensions"][0]
        ga.web_users_day = @user[i]["metrics"][0]["values"][0].to_f

        if !@user_7.nil? && @user_7[i]["dimensions"][0] == date
          ga.web_users_week = @user_7[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have user_7 data"
        end

        if !@user_30.nil? && @user_30[i]["dimensions"][0] == date
          ga.web_users_month = @user_30[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have user_30 data"
        end

        if !@session_pageview.nil? && @session_pageview[i]["dimensions"][0] == date
          ga.session_pageviews_day = @session_pageview[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have session_pageview data"
        end

        if !@session.nil? && @session[i]["dimensions"][0] == date
          ga.sessions_day = @session[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have sessions_day data"
        end

        if !@bounce.nil? && @bounce[i]["dimensions"][0] == date
          ga.bouce_rate_day = @bounce[i]["metrics"][0]["values"][0].to_f
        else 
          puts "didn't have bounce data"
        end

        if !@pageview.nil? && @pageview[i]["dimensions"][0] == date
          ga.pageviews_day = @pageview[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have pageviews day"
        end

        if !@avg_session.nil? && @avg_session[i]["dimensions"][0] == date
          ga.avg_session_duration_day = @avg_session[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have avg_session data"
        end

        if !@avg_time_page.nil? && @avg_time_page[i]["dimensions"][0] == date
          ga.avg_time_on_page_day = @avg_time_page[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have avg_time data"
        end

        if !@page_per_session.nil? && @page_per_session[i]["dimensions"][0] == date
          ga.pageviews_per_session_day = @page_per_session[i]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have page_per data"
        end

        if !@device.nil? && @device[b]["dimensions"][0] == date
          ga.desktop_user = @device[b]["metrics"][0]["values"][0].to_f
          ga.mobile_user = @device[b]["metrics"][0]["values"][0].to_f
          ga.tablet_user = @device[b + 2]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have device data"
        end

        if !@user_type.nil? && @user_type[d]["dimensions"][0] == date
          ga.new_visitor = @user_type[d]["metrics"][0]["values"][0].to_f
          ga.return_visitor = @user_type[d + 1]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have user_type data"
        end

        if !@gender.nil? && @gender[d]["dimensions"][0] == date
          ga.female_user = @gender[d]["metrics"][0]["values"][0].to_f
          ga.male_user = @gender[d + 1]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have gender data"
        end

        if !@bracket.nil? && @bracket[e]["dimensions"][0] == date
          ga.user_18_24 = @bracket[e]["metrics"][0]["values"][0].to_f
          ga.user_25_34 = @bracket[e + 1]["metrics"][0]["values"][0].to_f
          ga.user_35_44 = @bracket[e + 2]["metrics"][0]["values"][0].to_f
          ga.user_45_54 = @bracket[e + 3]["metrics"][0]["values"][0].to_f
          ga.user_55_64 = @bracket[e + 4]["metrics"][0]["values"][0].to_f
          ga.user_65 = @bracket[e + 5]["metrics"][0]["values"][0].to_f
        else
          puts "didn't have bracket data"
        end

        if @channel[c]["dimensions"][1] == "Direct" 
          ga.direct_user_day = @channel[c]["metrics"][0]["values"][0].to_f
          ga.direct_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        elsif @channel[c]["dimensions"][1] == "(Other)"
          c += 1
          ga.direct_user_day = @channel[c]["metrics"][0]["values"][0].to_f
          ga.direct_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        end

        if @channel[c]["dimensions"][1] == "Email" 
          ga.email_user_day = @channel[c]["metrics"][0]["values"][0].to_f 
          ga.email_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        elsif @channel[c]["dimensions"][1] == "Display"
          c += 1
          if @channel[c]["dimensions"][1] == "Email" 
            ga.email_user_day = @channel[c]["metrics"][0]["values"][0].to_f 
            ga.email_bounce = @channel[c]["metrics"][0]["values"][1].to_f
            c += 1
          end
        end
            
        if @channel[c]["dimensions"][1] == "Organic Search"
          ga.oganic_search_day = @channel[c]["metrics"][0]["values"][0].to_f
          ga.oganic_search_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        end

        if @channel[c]["dimensions"][1] == "Referral"
          ga.referral_user_day = @channel[c]["metrics"][0]["values"][0].to_f
          ga.referral_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        end

        if @channel[c]["dimensions"][1] == "Social" 
          ga.social_user_day = @channel[c]["metrics"][0]["values"][0].to_f
          ga.social_bounce = @channel[c]["metrics"][0]["values"][1].to_f
          c += 1
        end

        ga.single_session = @single[i]["metrics"][0]["values"][0].to_f
        ga.save!

        b += 3
        e += 6
        d += 2
        c += 1
        i += 1
      end
    end
  end
end
