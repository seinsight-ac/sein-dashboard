require 'sidekiq-scheduler'

class GrabFbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = FbDb.count

    @fb = Koala::Facebook::API.new(CONFIG.FB_TOKEN)

    @fan = get_3_days_data("page_fans").first.first.second
    @fan_add = get_3_days_data("page_fan_adds_unique")
    @fan_lost = get_3_days_data("page_fan_removes_unique")
    @page = get_3_days_data("page_impressions_unique")
    @post = get_3_days_data("page_posts_impressions_unique")
    @enagement = get_3_days_data("page_engaged_users")
    @negative = get_3_days_data("page_negative_feedback_unique")
    @post_enagement = get_3_days_data("page_post_engagements")
    @link_click = get_3_days_data("page_consumptions_by_consumption_type")
    @gender = get_3_days_data("page_fans_gender_age")

    set_fb_db

    puts "add #{FbDb.count - count} fb data"
  end

  def get_3_days_data(what)
    @fb.get_object("278666028863859/insights/#{what}?fields=values&date_preset=last_3_days")
  end

  def set_fb_db
    i = 0

    while i < @fan.length
      db_date = FbDb.last.date.to_date
      api_date = @fan[i]["end_time"].to_date

      if db_date >= api_date
        unless @gender[0].nil? || @gender[0]["values"][i].nil?
          puts "add gender data"
          old = FbDb.last
          old.fans_female_day = @gender[0]["values"][i]["value"].values[0..6].inject(0, :+)
          old.fans_male_day = @gender[0]["values"][i]["value"].values[7..13].inject(0, :+)
          old.fans_13_17 = @gender[0]["values"][i]["value"].values[0, 7].inject(0, :+)
          old.fans_18_24 = @gender[0]["values"][i]["value"].values[1, 8].inject(0, :+)
          old.fans_25_34 = @gender[0]["values"][i]["value"].values[2, 9].inject(0, :+)
          old.fans_35_44 = @gender[0]["values"][i]["value"].values[3, 10].inject(0, :+)
          old.fans_45_54 = @gender[0]["values"][i]["value"].values[4, 11].inject(0, :+)
          old.fans_55_64 = @gender[0]["values"][i]["value"].values[5, 12].inject(0, :+)
          old.fans_65 = @gender[0]["values"][i]["value"].values[6, 13].inject(0, :+)
          old.save!
        end
      elsif api_date.strftime("%Y-%m-%d") > Date.today.strftime("%Y-%m-%d")
        puts "data still change"
      else
        puts "add new fb data"
        puts "apidate #{api_date}"
        fb = FbDb.new
        fb.date = api_date
        fb.fans = @fan[i]["value"]

        if !@fan_add[0]["values"][i].nil? && @fan_add[0]["values"][i]["end_time"].to_date == api_date
          fb.fans_adds_day = @fan_add[0]["values"][i]["value"]
          fb.fans_adds_week = @fan_add[1]["values"][i]["value"]
          fb.fans_adds_month = @fan_add[2]["values"][i]["value"]
        else 
          puts "didn't have fan_add date"
        end

        if !@fan_lost[0]["values"][i].nil? && @fan_lost[0]["values"][i]["end_time"].to_date == api_date
          fb.fans_losts_day = @fan_lost[0]["values"][i]["value"]
          fb.fans_losts_week = @fan_lost[1]["values"][i]["value"]
          fb.fans_losts_month = @fan_lost[2]["values"][i]["value"]
        else 
          puts "didn't have fans_lost data"
        end

        if !@page[0]["values"][i].nil? && @page[0]["values"][i]["end_time"].to_date == api_date
          fb.page_users_day = @page[0]["values"][i]["value"]
          fb.page_users_week = @page[1]["values"][i]["value"]
          fb.page_users_month = @page[2]["values"][i]["value"]
        else
          puts "didn't have page data"
        end

        if !@post[0]["values"][i].nil? && @post[0]["values"][i]["end_time"].to_date == api_date
          fb.posts_users_day = @post[0]["values"][i]["value"]
          fb.posts_users_week = @post[1]["values"][i]["value"]
          fb.posts_users_month = @post[2]["values"][i]["value"]
        else
          puts "didn't have post data"
        end

        if !@post_enagement[0]["values"][i].nil? && @post_enagement[0]["values"][i]["end_time"].to_date == api_date
          fb.post_enagements_day = @post_enagement[0]["values"][i]["value"]
          fb.post_enagements_week = @post_enagement[1]["values"][i]["value"]
          fb.post_enagements_month = @post_enagement[2]["values"][i]["value"]
        else
          puts "didn't have post_enagement data"
        end

        if !@negative[0]["values"][i].nil? && @negative[0]["values"][i]["end_time"].to_date == api_date
          fb.negative_users_day = @negative[0]["values"][i]["value"]
          fb.negative_users_week = @negative[1]["values"][i]["value"]
          fb.negative_users_month = @negative[2]["values"][i]["value"]
        else
          puts "didn't have negative data"
        end

        if !@link_click[0]["values"][i].nil? && @link_click[0]["values"][i]["end_time"].to_date == api_date
          fb.link_clicks_day = @link_click[0]["values"][i]["value"]["link clicks"]
          fb.link_clicks_week = @link_click[1]["values"][i]["value"]["link clicks"]
          fb.link_clicks_month = @link_click[2]["values"][i]["value"]["link clicks"]
        else
          puts "didn't have link click data"
        end

        if !@gender[0].nil? && !@gender[0]["values"].nil? && !@gender[0]["values"][i].nil? && @gender[0]["values"][i]["end_time"].to_date == api_date
          fb.fans_female_day = @gender[0]["values"][i]["value"].values[0..6].inject(0, :+)
          fb.fans_male_day = @gender[0]["values"][i]["value"].values[7..13].inject(0, :+)
          fb.fans_13_17 = @gender[0]["values"][i]["value"].values[0, 7].inject(0, :+)
          fb.fans_18_24 = @gender[0]["values"][i]["value"].values[1, 8].inject(0, :+)
          fb.fans_25_34 = @gender[0]["values"][i]["value"].values[2, 9].inject(0, :+)
          fb.fans_35_44 = @gender[0]["values"][i]["value"].values[3, 10].inject(0, :+)
          fb.fans_45_54 = @gender[0]["values"][i]["value"].values[4, 11].inject(0, :+)
          fb.fans_55_64 = @gender[0]["values"][i]["value"].values[5, 12].inject(0, :+)
          fb.fans_65 = @gender[0]["values"][i]["value"].values[6, 13].inject(0, :+)
        else
          puts "didn't have gender data"
        end

        if !@enagement[0]["values"][i].nil? && @enagement[0]["values"][i]["end_time"].to_date == api_date
          fb.enagements_users_day = @enagement[0]["values"][i]["value"]
          fb.enagements_users_week = @enagement[1]["values"][i]["value"]
          fb.enagements_users_month = @enagement[2]["values"][i]["value"]
        else
          puts "didn't have enagements data"
        end
        fb.save!
      end
      i += 1
    end
  end
end
