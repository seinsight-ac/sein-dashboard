class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def ga
    @active_user = GoogleAnalytics.active_user
    @avg_session_duration = GoogleAnalytics.avg_session_duration
    @pageviews_per_session = GoogleAnalytics.pageviews_per_session
    @session_count = GoogleAnalytics.session_count
    @single_session_user = @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @multi_session_user = @session_count.first[1][0]["data"]["totals"][0]["values"][0].to_i - @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0].to_i
    @channel_grouping = GoogleAnalytics.channel_grouping
    @channel_user = @channel_grouping.first[1][0]["data"]["totals"][0]["values"][0]
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
