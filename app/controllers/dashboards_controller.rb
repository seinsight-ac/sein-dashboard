class DashboardsController < ApplicationController
  before_action :authenticate_user!


  def ga
    # @active_users = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"]
    # @active_users_week = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"][7]["metrics"][0]["values"][0]
    # @active_users_lastweek = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @active_users_weekratef = @active_users_week.to_i * 10 / @active_users_lastweek.to_f
    # @active_users_weekrate = @active_users_weekratef.round(2)
    # @active_users_last7d = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    # @active_users_month = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"][30]["metrics"][0]["values"][0]
    # @active_users_lastmonth = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @active_users_monthratef = @active_users_month.to_i * 10 / @active_users_lastmonth.to_f
    # @active_users_monthrate = @active_users_monthratef.round(2)
    # @active_users_last30d = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    
    # @pageviews_per_session = GoogleAnalytics.pageviews_per_session

    # @session_pageviews_week = GoogleAnalytics.session_pageviews_week
    # @session_pageviews_week_total = GoogleAnalytics.session_pageviews_week.first[1][0]["data"]["totals"][0]["values"][0]
    # @single_session_pageviews_week = @session_pageviews_week.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @multi_session_pageviews_week = @session_pageviews_week_total.to_i - @single_session_pageviews_week.to_i
    # @activity = @multi_session_pageviews_week.to_i - @session_pageviews_week_total.to_i
    
    @pageviews_7d = GoogleAnalytics.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_7d = GoogleAnalytics.session_pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @multi_session_pageviews_7d = @pageviews_7d.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activity_7d = @multi_session_pageviews_7d.zip(@pageviews_7d).map{|k| (k[0] / k[1].to_f).round(2) }

    @pageviews_30d = GoogleAnalytics.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_30d = GoogleAnalytics.session_pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @multi_session_pageviews_30d = @pageviews_30d.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }
    @activity_30d = @multi_session_pageviews_30d.zip(@pageviews_30d).map{|k| (k[0] / k[1].to_f).round(2) }
    

    @channel_grouping_month = GoogleAnalytics.channel_grouping_month
    @channel_user_week = GoogleAnalytics.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @bounce_rate_week = GoogleAnalytics.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @channel_user_month = GoogleAnalytics.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @bounce_rate_month = GoogleAnalytics.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values.}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)

    @user_type = GoogleAnalytics.user_type

    @vistor = @user_type.first[1][0]["data"]["totals"][0]["values"][0]
    @new = @user_type.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @old = @user_type.first[1][0]["data"]["rows"][1]["metrics"][0]["values"][0]
    @device = GoogleAnalytics.device
    @tool = @device.first[1][0]["data"]["totals"][0]["values"][0]
  end

  def mailchimp
    @campaigns = Mailchimp.campaigns('2018-08-01', '2018-09-01')
    
    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")

    export_xls = ExportXls.new
    
    export_xls.mailchimp_xls(@campaigns)
    export_xls.alexa_xls(@sein, @newsmarket, @pansci, @einfo, @npost, @womany)
    
    respond_to do |format|
      format.xls { send_data(export_xls.export,
        :type => "text/excel; charset=utf-8; header=present",
        :filename => "社企流#{Date.today}資料分析.xls")
      }
      format.html
    end

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
    @pageusersmonth = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").third.first.second.first['value']     
    @pageusersweeklastweek = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").second.first.second.first['value'] 
    @pageusersmonthlastmonth = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").third.first.second.first['value']     
    @pageusersweekratef = @pageusersweek * 10 / @pageusersweeklastweek.to_f
    @pageusersweekrate = @pageusersweekratef.round(2)
    @pageusersmonthratef = @pageusersmonth * 10 / @pageusersmonthlastmonth.to_f
    @pageusersmonthrate = @pageusersmonthratef.round(2)
    @pageuserslast7d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").first['values'].flat_map{|i|i.values.first}
    @pageuserslast30d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").first['values'].flat_map{|i|i.values.first}
    

    @active_users = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"]
    @active_users_week = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"][7]["metrics"][0]["values"][0]
    @active_users_lastweek = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @active_users_weekratef = @active_users_week.to_i * 10 / @active_users_lastweek.to_f
    @active_users_weekrate = @active_users_weekratef.round(2)
    @active_users_last7d = GoogleAnalytics.active_7day_users.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @active_users_month = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"][30]["metrics"][0]["values"][0]
    @active_users_lastmonth = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @active_users_monthratef = @active_users_month.to_i * 10 / @active_users_lastmonth.to_f
    @active_users_monthrate = @active_users_monthratef.round(2)
    @active_users_last30d = GoogleAnalytics.active_30day_users.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    
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
