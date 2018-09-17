class DashboardsController < ApplicationController
  before_action :authenticate_user!


  def ga

    ga = GoogleAnalytics.new
    
    # @avg_session_duration = ga.avg_session_duration
    # @pageviews_per_session = ga.pageviews_per_session
    # @session_count = ga.session_count
    # @single_session_user = @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @multi_session_user = @session_count.first[1][0]["data"]["totals"][0]["values"][0].to_i - @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0].to_i
    
    # @session_pageviews_week = ga.session_pageviews_week
    # @session_pageviews_week_total = GoogleAnalytics.session_pageviews_week.first[1][0]["data"]["totals"][0]["values"][0]
    # @single_session_pageviews_week = @session_pageviews_week.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @multi_session_pageviews_week = @session_pageviews_week_total.to_i - @single_session_pageviews_week.to_i
    # @activity = @multi_session_pageviews_week.to_i / @session_pageviews_week_total.to_i
    
    #使用者活躍度分析
    @pageviews_7d = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_7d = ga.session_pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @multi_session_pageviews_7d = @pageviews_7d.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activity_7d = @multi_session_pageviews_7d.zip(@pageviews_7d).map{|k| (k[0] / k[1].to_f).round(2) }
    @activity_date_7d = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,7]
    
    @pageviews_30d = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_30d = ga.session_pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @multi_session_pageviews_30d = @pageviews_30d.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }
    @activity_30d = @multi_session_pageviews_30d.zip(@pageviews_30d).map{|k| (k[0] / k[1].to_f).round(2) }
    @activity_date_30d = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,30]
    #流量管道
    @channel_user_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @bounce_rate_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @channel_user_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @bounce_rate_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)


    # @user_type = ga.user_type
    # @vistor = @user_type.first[1][0]["data"]["totals"][0]["values"][0]
    # @new = @user_type.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @old = @user_type.first[1][0]["data"]["rows"][1]["metrics"][0]["values"][0]
    # @device = ga.device
    # @tool = @device.first[1][0]["data"]["totals"][0]["values"][0]

  end

  def mailchimp
    t = Time.now
    t.utc
    month_age = t - 60 * 60 * 24 *30
    t.strftime("%Y-%m-%d")
    month_age.strftime("%Y-%m-%d")
    @campaigns = Mailchimp.campaigns(month_age, t)
    
    alexa_api

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
    # facebook API
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    # facebook fans
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
    @fansaddsweek = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=today").second.first.second.first['value'] 
    @fansaddsmonth = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=today").third.first.second.first['value'] 
    @fansaddslast7d = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_7d").first['values'].flat_map{ |i|i.values.first }
    @fansaddslast30d = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_30d").first['values'].flat_map{ |i|i.values.first }
    @fansaddsweekratef = @fansaddsweek * 1000 / (@fans - @fansaddsweek).to_f
    @fansaddsweekrate = @fansaddsweekratef.round(2)
    @fansaddsmonthratef = @fansaddsmonth * 1000 / (@fans - @fansaddsmonth).to_f
    @fansaddsmonthrate = @fansaddsmonthratef.round(2)
    
    # facebook page users
    @pageusersweek = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").second.first.second.first['value'] 
    @pageusersmonth = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").third.first.second.first['value']     
    @pageusersweeklastweek = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").second.first.second.first['value'] 
    @pageusersmonthlastmonth = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").third.first.second.first['value']     
    @pageusersweekratef = @pageusersweek * 10 / @pageusersweeklastweek.to_f
    @pageusersweekrate = @pageusersweekratef.round(2)
    @pageusersmonthratef = @pageusersmonth * 10 / @pageusersmonthlastmonth.to_f
    @pageusersmonthrate = @pageusersmonthratef.round(2)

    @pageuserslast7d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").first['values'].flat_map{ |i|i.values.first }
    @pageuserslast30d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").first['values'].flat_map{ |i|i.values.first }
    
    # facebook fans retention
    @pageimpressionslast7ddata = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_7d").first['values'].flat_map{ |i|i.values.first }    
    @last7ddate = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_7d").first['values'].flat_map{ |i|i.values.second }.map{ |i| i.split('T').first.split('-').join()[4..7].to_i }
    @pageimpressionslast30ddata = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d").first['values'].flat_map{ |i|i.values.first }    
    @last30ddate = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d").first['values'].flat_map{ |i|i.values.second }.map{ |i| i.split('T').first.split('-').join()[4..7].to_i }
    @postenagementslast7ddata = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_7d").first['values'].flat_map{ |i|i.values.first }
    @postenagementslast30ddata = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_30d").first['values'].flat_map{ |i|i.values.first }
    @fansretentionrate7d = Array.new
    @fansretentionrate7d = @postenagementslast7ddata.zip(@pageimpressionslast7ddata).map{|x, y| x / y.to_f}
    @fansretentionrate7d = @fansretentionrate7d.map{ |i| i.round(3) }
    @fansretentionrate30d = Array.new
    @fansretentionrate30d = @postenagementslast30ddata.zip(@pageimpressionslast30ddata).map{|x, y| x / y.to_f}
    @fansretentionrate30d = @fansretentionrate30d.map{ |i| i.round(3) }
    
    #google
    ga = GoogleAnalytics.new
    @webusersweek = ga.webusersweek.first[1][0]["data"]["rows"][7]["metrics"][0]["values"][0]
    @webusersweeklastweek = ga.webusersweek.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @webusersweekratef = @webusersweek.to_i * 10 / @active_users_lastweek.to_f
    @webusersweekrate = @webusersweekratef.round(2)
    @webuserslast7d = ga.webusersweek.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @webusersmonth = ga.webusersmonth.first[1][0]["data"]["rows"][30]["metrics"][0]["values"][0]
    @webusersmonthlastmonth = ga.webusersmonth.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @webusersmonthratef = @webusersmonth.to_i * 10 / @active_users_lastmonth.to_f
    @webusersmonthrate = @webusersmonthratef.round(2)
    @webuserslast30d = ga.webusersmonth.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    
    #mailchimp
    t = Time.now
    t.utc
    month_age = t - 60 * 60 * 24 * 95 # 要一季的資料就95天 要一個月的資料就31天
    t.strftime("%Y-%m-%d")
    month_age.strftime("%Y-%m-%d")

    @campaigns = Mailchimp.campaigns(month_age, t)

    @mailusers = @campaigns[0]["emails_sent"]
    @mailusersmonthrate = (@campaigns[0]["emails_sent"] - @campaigns[1]["emails_sent"]) * 10000 / @campaigns[1]["emails_sent"]
    @last12wdate = Array.new
    (0..3).each do |i| # 看要多少資料量
        @last12wdate << @campaigns[i]["emails_sent"]
    end

    @mailsviews = Array.new
    (0..3).each do |i|
       @mailsviews << @campaigns[i]["report_summary"]["opens"]
    end

    # alexa
    alexa_api
    @womanyrank = rank(@womany)
    @panscirank = rank(@pansci)
    @newsmarketrank = rank(@newsmarket)
    @einforank = rank(@einfo)
    @seinrank = rank(@sein)
    @npostrank = rank(@npost)
    @womanyrate = convert_rate(@womany)
    @panscirate = convert_rate(@pansci)
    @newsmarketrate = convert_rate(@newsmarket)
    @einforate = convert_rate(@einfo)
    @seinrate = convert_rate(@sein)
    @npostrate = convert_rate(@npost)
  end

  private

  def alexa_api
    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")
  end

  def convert_rate(data)
    return data[2].inner_text.to_i / 100.to_f
  end

  def rank(data)
    return data[1].inner_text.delete(',').to_i
  end
  
end
