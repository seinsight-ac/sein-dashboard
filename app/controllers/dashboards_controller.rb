class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :fbinformation, :only => [:index, :facebook]

  def facebook
    @fansgenderage = @graph.get_object("278666028863859/insights/page_fans_gender_age?fields=values").first.first.second.second["value"]
    @fansfemale = @fansgenderage.values[0..6].inject(0, :+)
    @fansmale = @fansgenderage.values[7..13].inject(0, :+)
  end

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
    @allusersviewslast7ddata = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_7d = ga.session_pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @activeusersviewslast7ddata = @allusersviewslast7ddata.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @usersactivityrate7d = @activeusersviewslast7ddata.zip(@allusersviewslast7ddata).map{|k| (k[0] / k[1].to_f).round(2) }
    @last7ddateg = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,7]
    @allusersviewslast30ddata = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_30d = ga.session_pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @activeusersviewslast30ddata = @allusersviewslast30ddata.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }
    @usersactivityrate30d = @activeusersviewslast30ddata.zip(@allusersviewslast30ddata).map{|k| (k[0] / k[1].to_f).round(2) }
    @last30ddateg = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,30].grep(/\d+/, &:to_i)
    #流量管道
    @channel_user_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_week = @channel_user_week[2],@channel_user_week[4], @channel_user_week[0], @channel_user_week[3], @channel_user_week[1]
    @bounce_rate_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_week = @bounce_rate_week[2],@bounce_rate_week[4], @bounce_rate_week[0], @bounce_rate_week[3], @bounce_rate_week[1]
    @channel_user_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_month = @channel_user_month[2],@channel_user_month[4], @channel_user_month[0], @channel_user_month[3], @channel_user_month[1]    
    @bounce_rate_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_month = @bounce_rate_month[2],@bounce_rate_month[4], @bounce_rate_month[0], @bounce_rate_month[3], @bounce_rate_month[1]

    # @user_type = ga.user_type
    # @vistor = @user_type.first[1][0]["data"]["totals"][0]["values"][0]
    # @new = @user_type.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    # @old = @user_type.first[1][0]["data"]["rows"][1]["metrics"][0]["values"][0]
    # @device = ga.device
    # @tool = @device.first[1][0]["data"]["totals"][0]["values"][0]

  end

  def mailchimp
    set_time
    @campaigns = Mailchimp.campaigns(@month, @now)
    
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
  
    #google
    ga = GoogleAnalytics.new
    #官網使用者
    @webusersweek = ga.webusersweek.first[1][0]["data"]["rows"][7]["metrics"][0]["values"][0]
    @webusersweeklastweek = ga.webusersweek.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @webusersweekratef = @webusersweek.to_i * 10 / @webusersweeklastweek.to_f
    @webusersweekrate = @webusersweekratef.round(2)
    @webuserslast7d = ga.webusersweek.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @webusersmonth = ga.webusersmonth.first[1][0]["data"]["rows"][30]["metrics"][0]["values"][0]
    @webusersmonthlastmonth = ga.webusersmonth.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @webusersmonthratef = @webusersmonth.to_i * 10 / @webusersmonthlastmonth.to_f
    @webusersmonthrate = @webusersmonthratef.round(2)
    @webuserslast30d = ga.webusersmonth.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)

    #使用者活躍度分析
    @allusersviewslast7ddata = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_7d = ga.session_pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @activeusersviewslast7ddata = @allusersviewslast7ddata.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @usersactivityrate7d = @activeusersviewslast7ddata.zip(@allusersviewslast7ddata).map{|k| (k[0] / k[1].to_f).round(2) }
    @last7ddateg = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,7].grep(/\d+/, &:to_i)
    
    @allusersviewslast30ddata = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @single_session_pageviews_30d = ga.session_pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,30].flat_map{|i|i}.grep(/\d+/, &:to_i)
    @activeusersviewslast30ddata = @allusersviewslast30ddata.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }
    @usersactivityrate30d = @activeusersviewslast30ddata.zip(@allusersviewslast30ddata).map{|k| (k[0] / k[1].to_f).round(2) }
    @last30ddateg = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,30].grep(/\d+/, &:to_i)
    #流量管道
    @channel_user_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_week = @channel_user_week[2],@channel_user_week[4], @channel_user_week[0], @channel_user_week[3], @channel_user_week[1]
    @bounce_rate_week = ga.channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_week = @bounce_rate_week[2],@bounce_rate_week[4], @bounce_rate_week[0], @bounce_rate_week[3], @bounce_rate_week[1]
    @channel_user_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_month = @channel_user_month[2],@channel_user_month[4], @channel_user_month[0], @channel_user_month[3], @channel_user_month[1]    
    @bounce_rate_month = ga.channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_month = @bounce_rate_month[2],@bounce_rate_month[4], @bounce_rate_month[0], @bounce_rate_month[3], @bounce_rate_month[1]
    #mailchimp
    set_time

    @campaigns = Mailchimp.campaigns(@month, @now)

    @mailusers = @campaigns[0]["emails_sent"]
    @mailusersmonthrate = rate_transit(@campaigns[0]["emails_sent"], @campaigns[1]["emails_sent"])

    @mailuserslast30d = set_mailchimp_array_month_simple("emails_sent")
    @last12wdate = set_mailchimp_array_month_date("send_time")

    @mailsviews = set_mailchimp_array_month("report_summary", "opens")
    @maillinks= set_mailchimp_array_month("report_summary", "subscriber_clicks")
    @mailsviewsrate = set_mailchimp_array_month("report_summary", "open_rate")
    @maillinksrate = set_mailchimp_array_month("report_summary", "click_rate")

    #alexa
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

  def set_time
    @now = Time.now
    @now.utc
    @month = @now - 60 * 60 * 24 * 35
    @now.strftime("%Y-%m-%d")
    @month.strftime("%Y-%m-%d")
  end

  def rate_transit(datanew, dataold)
    return ((datanew - dataold) / dataold.to_f * 10000).round(2)
  end

  def fbinformation

    # facebook API
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    # facebook fans
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
    @fansadds = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_30d")
    @fansaddsweek = @fansadds.second['values'].flat_map{ |i|i.values.first }[29]
    @fansaddsmonth = @fansadds.third['values'].flat_map{ |i|i.values.first }[29]
    @fansaddslast7d = @fansadds.first['values'].flat_map{ |i|i.values.first }[23..29]
    @fansaddslast30d = @fansadds.first['values'].flat_map{ |i|i.values.first }
    @fansaddsweekrate = convert_tenthousandthrate(@fansaddsweek, @fans)
    @fansaddsmonthrate = convert_tenthousandthrate(@fansaddsmonth, @fans)
    
    # facebook page users
    @pageusers = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d")
    @pageusersweek = @pageusers.second['values'].flat_map{ |i|i.values.first }[29]
    @pageusersmonth = @pageusers.third['values'].flat_map{ |i|i.values.first }[29]     
    @pageusersweeklastweek = @pageusers.second['values'].flat_map{ |i|i.values.first }[22]
    @pageusersmonthlastmonth = @pageusers.third['values'].flat_map{ |i|i.values.first }[22]     
    @pageusersweekrate = convert_percentrate(@pageusersweek, @pageusersweeklastweek) 
    @pageusersmonthrate = convert_percentrate(@pageusersmonth, @pageusersmonthlastmonth)
    @pageuserslast7d = @pageusers.first['values'].flat_map{ |i|i.values.first }[23..29]
    @pageuserslast30d = @pageusers.first['values'].flat_map{ |i|i.values.first }

    # facebook fans retention
    @pageimpressions = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d")
    @pageimpressionslast7ddata = @pageimpressions.first['values'].flat_map { |i|i.values.first }[23..29]
    @pageimpressionslast30ddata = @pageimpressions.first['values'].flat_map { |i|i.values.first }
    @last7ddate = @pageimpressions.first['values'].flat_map{ |i|i.values.second }[23..29].map { |i| divide_date(i) }
    @last30ddate = @pageimpressions.first['values'].flat_map{ |i|i.values.second }.map{ |i| divide_date(i) }
    @postenagements = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_30d")
    @postenagementslast7ddata = @postenagements.first['values'].flat_map { |i|i.values.first }[23..29]
    @postenagementslast30ddata = @postenagements.first['values'].flat_map { |i|i.values.first }
    @fansretentionrate7d = []
    @fansretentionrate7d = @postenagementslast7ddata.zip(@pageimpressionslast7ddata).map { |x, y| x / y.to_f }
    @fansretentionrate7d = @fansretentionrate7d.map{ |i| i.round(3) }
    @fansretentionrate30d = []
    @fansretentionrate30d = @postenagementslast30ddata.zip(@pageimpressionslast30ddata).map { |x, y| x / y.to_f }
    @fansretentionrate30d = @fansretentionrate30d.map { |i| i.round(3) }

  end

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

  def convert_tenthousandthrate(datanew,  dataold)
      return (datanew * 10000 / (dataold - datanew).to_f).round(2)
  end

  def convert_percentrate(datanew,  dataold)
    return ((datanew - dataold) / dataold.to_f * 100).round(2)
  end

  def set_mailchimp_array_month(range1, range2)
    array = []
    (0..3).each do |i|
        array << @campaigns[i][range1][range2]
    end
    array.reverse!
    return array
  end

  def set_mailchimp_array_month_simple(range)
    array = []
    (0..3).each do |i|
        array << @campaigns[i][range]
    end
    array.reverse!
    return array
  end

  def set_mailchimp_array_month_date(range)
    array = []
    (0..3).each do |i|
        array << divide_date(@campaigns[i][range])
    end
    array.reverse!
    return array
  end

  def divide_date(date)
    return date.split('T').first.split('-').join()[4..7].to_i 
  end

end
