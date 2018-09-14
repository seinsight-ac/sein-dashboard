class DashboardsController < ApplicationController

  before_action :authenticate_user!
  require 'json'


  def ga
    @active_user = GoogleAnalytics.active_user(current_user.google_token) 
    @avg_session_duration = GoogleAnalytics.avg_session_duration(current_user.google_token)
    @pageviews_per_session = GoogleAnalytics.pageviews_per_session(current_user.google_token)
    @session_count = GoogleAnalytics.session_count(current_user.google_token)
    @single_session_user = @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @multi_session_user = @session_count.first[1][0]["data"]["totals"][0]["values"][0].to_i - @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0].to_i
  end

  def mailchimp
    @campaigns = Mailchimp.campaigns('2018-08-01', '2018-09-01')
  end

  def index
    require 'koala'
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
    @fansaddsweek = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=today").second.first.second.first['value'] 
    @fansaddsmonth = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=today").third.first.second.first['value'] 
    @fansaddslast7d = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_7d").first['values'].flat_map{|i|i.values.first}
    @fansaddslast30d = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_30d").first['values'].flat_map{|i|i.values.first}
    @fansaddsweekratef = @fansaddsweek * 1000 / (@fans - @fansaddsweek).to_f
    @fansaddsweekrate = @fansaddsweekratef.round(2)
    @fansaddsmonthratef = @fansaddsmonth * 1000 / (@fans - @fansaddsmonth).to_f
    @fansaddsmonthrate = @fansaddsmonthratef.round(2)
    @pageusersweek = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").second.first.second.first['value'] 
    @pageusersweeklast_7d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").second.first.second.first['value'] 
    @pageusersweekratef = @pageusersweek * 10 / @pageusersweeklast_7d.to_f.round(2)
    @pageusersweekrate = @pageusersweekratef.round(2)
  end

  
  def alexa
    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")
  end 
end
