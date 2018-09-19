class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :fbinformation, :only => [:index, :facebook]


  def index
  
    #google
    ga = GoogleAnalytics.new
    web_users_week = ga.web_users_week
    web_users_month = ga.web_users_month
    #官網使用者
    @web_users_week = web_users_week.first[1][0]["data"]["rows"][7]["metrics"][0]["values"][0]
    @web_users_week_last_week = web_users_week.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]

    @web_users_month = web_users_month.first[1][0]["data"]["rows"][30]["metrics"][0]["values"][0]
    @web_users_month_last_month = web_users_month.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]

    @web_users_week_rate = (@web_users_week.to_i * 10 / @web_users_week_last_week.to_f).round(2)
    @web_users_month_rate = (@web_users_month.to_i * 10 / @web_users_month_last_month.to_f).round(2)

    @web_users_last_7d = ga_data(web_users_week, 7)
    @web_users_last_30d = ga_data(web_users_week, 30)

    #使用者活躍度分析
    pageviews_7d, = ga.pageviews_7d
    pageviews_30d, = ga.pageviews_30d

    @all_users_views_last_7d_data = ga_data(pageviews_7d, 7)
    @all_users_views_last_30d_data = ga_data(pageviews_30d, 30)

    @single_session_pageviews_7d = ga_data(ga.session_pageviews_7d, 7)
    @single_session_pageviews_30d = ga_data(ga.session_pageviews_30d, 30)

    @all_users_views_last_30d_data = ga_data(pageviews_30d, 30)

    @activeusers_views_last_7d_data = @all_users_views_last_7d_data.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activeusers_views_last_30d_data = @all_users_views_last_30d_data.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }

    @users_activity_rate_7d = @activeusers_views_last_7d_data.zip(@all_users_views_last_7d_data).map{|k| (k[0] / k[1].to_f).round(2) }
    @users_activity_rate_30d = @activeusers_views_last_30d_data.zip(@all_users_views_last_30d_data).map{|k| (k[0] / k[1].to_f).round(2) }

    @ga_last_7d_date = ga_data(pageviews_7d, 7)
    @ga_last_30d_date = ga_data(pageviews_30d, 30)

    #流量管道ra
    channel_grouping_week = ga.channel_grouping_week
    channel_grouping_month = ga.channel_grouping_month

    @channel_user_week = channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_week = @channel_user_week[2], @channel_user_week[4], @channel_user_week[0], @channel_user_week[3], @channel_user_week[1]

    @bounce_rate_week = channel_grouping_week.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_week = @bounce_rate_week[2], @bounce_rate_week[4], @bounce_rate_week[0], @bounce_rate_week[3], @bounce_rate_week[1]

    @channel_user_month = channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.first}.grep(/\d+/, &:to_i)
    @channel_user_month = @channel_user_month[2], @channel_user_month[4], @channel_user_month[0], @channel_user_month[3], @channel_user_month[1] 

    @bounce_rate_month = channel_grouping_month.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}.values_at(1,3,4,5,6).flat_map{|i|i.second}.grep(/\d+/, &:to_i)
    @bounce_rate_month = @bounce_rate_month[2], @bounce_rate_month[4], @bounce_rate_month[0], @bounce_rate_month[3], @bounce_rate_month[1]
    
    #mailchimp
    set_time

    @campaigns = Mailchimp.campaigns(@month, @now)

    @mail_users = @campaigns[0]["emails_sent"]
    @mail_users_month_rate = rate_transit(@campaigns[0]["emails_sent"], @campaigns[1]["emails_sent"])

    @mail_users_last_30d = set_mailchimp_array_month_simple("emails_sent")
    @last_12w_date = set_mailchimp_array_month_date("send_time")

    @mail_views = set_mailchimp_array_month("report_summary", "opens")
    @mail_links= set_mailchimp_array_month("report_summary", "subscriber_clicks")
    @mail_views_rate = set_mailchimp_array_month_rate("report_summary", "open_rate")
    @mail_links_rate = []
    @mail_links.zip(@mail_views) { |a, b| @mail_links_rate << a / b.to_f }

    #alexa
    alexa_api

    alexa = [@womany, @pansci, @newsmarket, @einfo, @sein, @npost]

    @rank = rank(alexa)
    @rate = convert_rate(alexa)
  end

  def facebook
    @fans_gender_age = @graph.get_object("278666028863859/insights/page_fans_gender_age?fields=values").first.first.second.second["value"]
    @fans_female = @fans_gender_age.values[0..6].inject(0, :+)
    @fans_male = @fans_gender_age.values[7..13].inject(0, :+)
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

  private

  # 上個月星期一的日期 往後推七天
  def last_month_mon
    d = Date.today
    d = d << 1
    d = d.to_s
    @last = Date.new(d[0..3].to_i, d[5..6].to_i, 1)
    while @last.strftime("%a") != "Mon"
      @last -= 1
    end
    @last = @last.strftime("%Y-%m-%d") # 格式2018-08-18
  end

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

  def divide_date(date)
    date.split('T').first.split('-').join()[4..7].to_i 
  end

  def fbinformation

    # facebook API
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    # facebook fans
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
    @fans_adds = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_30d")
    @fans_adds_week = @fans_adds.second['values'].flat_map{ |i|i.values.first }[29]
    @fans_adds_month = @fans_adds.third['values'].flat_map{ |i|i.values.first }[29]
    @fans_adds_last_7d = @fans_adds.first['values'].flat_map{ |i|i.values.first }[23..29]
    @fans_adds_last_30d = @fans_adds.first['values'].flat_map{ |i|i.values.first }
    @fans_adds_week_rate = convert_tenthousandthrate(@fans_adds_week, @fans)
    @fans_adds_month_rate = convert_tenthousandthrate(@fans_adds_month, @fans)
    

    # facebook page users
    @pageusers = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d")
    @page_users_week = @pageusers.second['values'].flat_map{ |i|i.values.first }[29]
    @page_users_month = @pageusers.third['values'].flat_map{ |i|i.values.first }[29]     
    @page_users_week_last_week = @pageusers.second['values'].flat_map{ |i|i.values.first }[22]
    @page_users_month_last_month = @pageusers.third['values'].flat_map{ |i|i.values.first }[22]     
    @page_users_week_rate = convert_percentrate(@page_users_week, @page_users_week_last_week) 
    @page_users_month_rate = convert_percentrate(@page_users_month, @page_users_month_last_month)
    @page_users_last_7d = @pageusers.first['values'].flat_map{ |i|i.values.first }[23..29]
    @page_users_last_30d = @pageusers.first['values'].flat_map{ |i|i.values.first }

    # facebook fans retention
    @pageimpressions = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d")
    @page_impressions_last_7d_data = @pageimpressions.first['values'].flat_map { |i|i.values.first }[23..29]
    @page_impressions_last_30d_data = @pageimpressions.first['values'].flat_map { |i|i.values.first }
    @fb_last_7d_date = @pageimpressions.first['values'].flat_map{ |i|i.values.second }[23..29].map { |i| divide_date(i) }
    @fb_last_30d_date = @pageimpressions.first['values'].flat_map{ |i|i.values.second }.map{ |i| divide_date(i) }
    @postenagements = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_30d")
    @post_enagements_last_7d_data = @postenagements.first['values'].flat_map { |i|i.values.first }[23..29]
    @post_enagements_last_30d_data = @postenagements.first['values'].flat_map { |i|i.values.first }
    @fans_retention_rate_7d = []
    @fans_retention_rate_7d = @post_enagements_last_7d_data.zip(@post_enagements_last_7d_data).map { |x, y| x / y.to_f }
    @fans_retention_rate_7d = @fans_retention_rate_7d.map{ |i| i.round(3) }
    @fans_retention_rate_30d = []
    @fans_retention_rate_30d = @post_enagements_last_30d_data.zip(@post_enagements_last_30d_data).map { |x, y| x / y.to_f }
    @fans_retention_rate_30d = @fans_retention_rate_30d.map { |i| i.round(3) }

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
    array = []
    data.each do |d|
      array << d[2].inner_text.to_i / 100.to_f
    end
    array
  end

  def rank(data)
    array = []
    data.each do |d|
      array << d[1].inner_text.delete(',').to_i
    end
    array
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
  end

  def set_mailchimp_array_month_rate(range1, range2)
    array = []
    (0..3).each do |i|
        array << @campaigns[i][range1][range2].round(2)
    end
    array.reverse!
  end

  def set_mailchimp_array_month_simple(range)
    array = []
    (0..3).each do |i|
        array << @campaigns[i][range]
    end
    array.reverse!
  end

  def set_mailchimp_array_month_date(range)
    array = []
    (0..3).each do |i|
        array << divide_date(@campaigns[i][range])
    end
    array.reverse!
  end

  def ga_data(data, day)
    data.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
  end

end
