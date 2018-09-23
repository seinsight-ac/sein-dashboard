class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :fbinformation, :only => [:index, :facebook]
  before_action :index, :only => [:googleanalytics]

<<<<<<< HEAD
  def ga_data(data, day)
    data.first[1][0]["data"]["rows"].flat_map{|i|i.values.second}.flat_map{|i|i.values}[1,7].flat_map{|i|i}.grep(/\d+/, &:to_i)
  end

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
    @all_users_views_last_7d_data = ga_data(ga.pageviews_7d, 7)
    @all_users_views_last_30d_data = ga_data(ga.pageviews_30d, 30)

    @single_session_pageviews_7d = ga_data(ga.session_pageviews_7d, 7)
    @single_session_pageviews_30d = ga_data(ga.session_pageviews_30d, 30)

    @all_users_views_last_30d_data = ga_data(ga.pageviews_30d, 30)

    @activeusers_views_last_7d_data = @all_users_views_last_7d_data.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activeusers_views_last_30d_data = @all_users_views_last_30d_data.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }

    @users_activity_rate_7d = @activeusers_views_last_7d_data.zip(@all_users_views_last_7d_data).map{|k| (k[0] / k[1].to_f).round(2) }
    @users_activity_rate_30d = @activeusers_views_last_30d_data.zip(@all_users_views_last_30d_data).map{|k| (k[0] / k[1].to_f).round(2) }

    @ga_last_7d_date = ga.pageviews_7d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,7].grep(/\d+/, &:to_i)
    @ga_last_30d_date = ga.pageviews_30d.first[1][0]["data"]["rows"].flat_map{|i|i.values.first}[1,30].grep(/\d+/, &:to_i)

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

    @womany_rank = rank(@womany)
    @pansci_rank = rank(@pansci)
    @newsmarket_rank = rank(@newsmarket)
    @einfo_rank = rank(@einfo)
    @sein_rank = rank(@sein)
    @npost_rank = rank(@npost)

    @womany_rate = convert_rate(@womany)
    @pansci_rate = convert_rate(@pansci)
    @newsmarket_rate = convert_rate(@newsmarket)
    @einfo_rate = convert_rate(@einfo)
    @sein_rate = convert_rate(@sein)
    @npost_rate = convert_rate(@npost)
  end

  def facebook
    @fans_gender_age = @graph.get_object("278666028863859/insights/page_fans_gender_age?fields=values").first.first.second.second["value"]
    @fans_female = @fans_gender_age.values[0..6].inject(0, :+)
    @fans_male = @fans_gender_age.values[7..13].inject(0, :+)
  end

  def ga
=======
  def index
    # google
    @web_users_week = GaDb.last(7).pluck(:web_users_week).reduce(:+)
    @web_users_month = GaDb.last(30).pluck(:web_users_week).reduce(:+)
>>>>>>> ff65e6dcc40f03ec44ce2ed566ede8e7a732d628

    @web_users_last_7d = GaDb.last(7).pluck(:web_users_week)
    @web_users_last_30d = GaDb.last(30).pluck(:web_users_week)
    
    @web_users_week_rate = convert_percentrate(@web_users_week, GaDb.last(14).first(7).pluck(:web_users_week).reduce(:+))  
    @web_users_month_rate = convert_percentrate(@web_users_month, GaDb.last(60).first(30).pluck(:web_users_week).reduce(:+))

    @all_users_views_last_7d_data = GaDb.last(7).pluck(:pageviews_day)
    @all_users_views_last_30d_data = GaDb.last(30).pluck(:pageviews_day)

    @single_session_pageviews_7d = GaDb.last(7).pluck(:session_pageviews_day).map { |a| a.round(2) }
    @single_session_pageviews_30d = GaDb.last(30).pluck(:session_pageviews_day).map { |a| a.round(2) }

    @activeusers_views_last_7d_data = @all_users_views_last_7d_data.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activeusers_views_last_30d_data = @all_users_views_last_30d_data.zip(@single_session_pageviews_30d).map{|k| (k[0] - k[1]) }
  
    @users_activity_rate_7d = @activeusers_views_last_7d_data.zip(@all_users_views_last_7d_data).map{|k| (k[0] / k[1].to_f) }
    @users_activity_rate_30d = @activeusers_views_last_30d_data.zip(@all_users_views_last_30d_data).map{|k| (k[0] / k[1].to_f) }
    
    @ga_last_7d_date = GaDb.last(7).pluck(:date).map { |a| a.strftime("%m%d").to_i }
    @ga_last_30d_date = GaDb.last(30).pluck(:date).map { |a| a.strftime("%m%d").to_i }

    @channel_user_week = [GaDb.last(7).pluck(:oganic_search_day).compact.reduce(:+), GaDb.last(7).pluck(:social_user_day).compact.reduce(:+), GaDb.last(7).pluck(:direct_user_day).compact.reduce(:+), GaDb.last(7).pluck(:referral_user_day).compact.reduce(:+), GaDb.last(7).pluck(:email_user_day).compact.reduce(:+)]
    @bounce_rate_week = [GaDb.last(7).pluck(:oganic_search_bounce).compact.reduce(:+)/7, GaDb.last(7).pluck(:social_bounce).compact.reduce(:+)/7, GaDb.last(7).pluck(:direct_bounce).compact.reduce(:+)/7, GaDb.last(7).pluck(:referral_bounce).compact.reduce(:+)/7,  GaDb.last(7).pluck(:email_bounce).compact.reduce(:+)/7]

    @channel_user_month = [GaDb.last(30).pluck(:oganic_search_day).compact.reduce(:+), GaDb.last(30).pluck(:social_user_day).compact.reduce(:+), GaDb.last(30).pluck(:direct_user_day).compact.reduce(:+), GaDb.last(30).pluck(:referral_user_day).compact.reduce(:+), GaDb.last(30).pluck(:email_user_day).compact.reduce(:+)]
    @channel_user_month = [GaDb.last(30).pluck(:oganic_search_bounce).compact.reduce(:+)/30, GaDb.last(30).pluck(:social_bounce).compact.reduce(:+)/30, GaDb.last(30).pluck(:direct_bounce).compact.reduce(:+)/30, GaDb.last(30).pluck(:referral_bounce).compact.reduce(:+)/30,  GaDb.last(30).pluck(:email_bounce).compact.reduce(:+)/30]

    @bounce_rate_week = GaDb.last(7).pluck(:bouce_rate_day)
    @bounce_rate_month = GaDb.last(30).pluck(:bouce_rate_day)
    
    # mailchimp
    @mail_users = MailchimpDb.last.email_sent
    @mail_users_month_rate = rate_transit(@mail_users, MailchimpDb.last(2).first.email_sent)

    @last_12w_date = []
    MailchimpDb.last(4).pluck(:date).each do |d|
      @last_12w_date << d.strftime("%m%d").to_i
    end
    @mail_users_last_30d = MailchimpDb.last(4).pluck(:email_sent)

    @mail_views = MailchimpDb.last(4).pluck(:open)
    @mail_links= MailchimpDb.last(4).pluck(:click)

    @mail_views_rate = []
    MailchimpDb.last(4).pluck(:open_rate).each do |open|
      @mail_views_rate << open.round(2)
    end

    @mail_links_rate = []
    @mail_links.zip(@mail_views) { |a, b| @mail_links_rate << a / b.to_f }

    # alexa
    @rank = AlexaDb.last(1).pluck(:womany_rank, :pansci_rank, :newsmarket_rank, :einfo_rank, :sein_rank, :npost_rank)[0]
    @rate = []
    AlexaDb.last(1).pluck(:womany_bounce_rate, :pansci_bounce_rate, :newsmarket_bounce_rate, :einfo_bounce_rate, :sein_bounce_rate, :npost_bounce_rate)[0].each do |rate|
      @rate << rate.round(2)
    end

    # export to xls
    export_xls = ExportXls.new
    
    #export_xls.mailchimp_xls(@campaigns)
    #export_xls.alexa_xls(@sein, @newsmarket, @pansci, @einfo, @npost, @womany)
    
    respond_to do |format|
      format.xls { send_data(export_xls.export,
        :type => "text/excel; charset=utf-8; header=present",
        :filename => "社企流#{(Date.today << 1).strftime("%m")[1]}月資料分析.xls")
      }
      format.html
    end
  end

<<<<<<< HEAD
=======
  def facebook
    # fb gender
    #@fans_gender_age = @graph.get_object("278666028863859/insights/page_fans_gender_age?fields=values")
    #@fans_gender = @fans_gender_age.first.first.second.first['value']
    @fans_female_day = FbDb.last(2).pluck(:fans_female_day).first
    @fans_male_day = FbDb.last(2).pluck(:fans_male_day).first
    @fans_13_17 = FbDb.last(2).pluck(:fans_13_17).first
    @fans_18_24 = FbDb.last(2).pluck(:fans_18_24).first
    @fans_25_34 = FbDb.last(2).pluck(:fans_25_34).first
    @fans_35_44 = FbDb.last(2).pluck(:fans_35_44).first
    @fans_45_54 = FbDb.last(2).pluck(:fans_45_54).first
    @fans_55_64 = FbDb.last(2).pluck(:fans_55_64).first
    @fans_65 = FbDb.last(2).pluck(:fans_65).first
    @fans_age = []
    @fans_age.push(@fans_13_17).push(@fans_18_24).push(@fans_25_34).push(@fans_35_44).push(@fans_45_54).push(@fans_55_64).push(@fans_65)
    # negative users
    #@negativeusers = @graph.get_object("278666028863859/insights/page_negative_feedback_unique?fields=values&date_preset=last_30d")
    @negative_users_week = FbDb.last(1).pluck(:negative_users_week).first
    @negative_users_month = FbDb.last(1).pluck(:negative_users_month).first
    @negative_users_week_last_week = FbDb.last(8).pluck(:negative_users_week).first
    @negative_users_month_last_month = FbDb.last(8).pluck(:negative_users_month).first   
    @negative_users_week_rate = convert_percentrate(@negative_users_week, @negative_users_week_last_week) 
    @negative_users_month_rate = convert_percentrate(@negative_users_month, @negative_users_month_last_month)
    @negative_users_last_7d = FbDb.last(7).pluck(:negative_users_day)
    @negative_users_last_30d = FbDb.last(30).pluck(:negative_users_day)

    # fans losts
    #@fanslosts = @graph.get_object("278666028863859/insights/page_fan_removes_unique?fields=values&date_preset=last_30d")
    @fans_losts_last_7d_data = FbDb.last(7).pluck(:fans_losts_day)
    @fans_losts_last_4w_data = FbDb.last(22).pluck(:fans_losts_week).values_at(0, 7, 14, 21)

    # link clicks
    #@postenagements = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_30d")
    @post_enagements_last_7d_data = FbDb.last(7).pluck(:post_enagements_day)
    @post_enagements_last_4w_data = FbDb.last(22).pluck(:post_enagements_week).values_at(0, 7, 14, 21)
    #@linkclicks = @graph.get_object("278666028863859/insights/page_consumptions_by_consumption_type?fields=values&date_preset=last_30d")
    @link_clicks_last_7d_data = FbDb.last(7).pluck(:link_clicks_day)
    @link_clicks_last_4w_data = FbDb.last(22).pluck(:link_clicks_week).values_at(0, 7, 14, 21)
    @link_clicks_rate_7d = []
    @link_clicks_rate_7d = @post_enagements_last_7d_data.zip(@link_clicks_last_7d_data).map { |x, y| (x / y.to_f).round(2) }
    @link_clicks_rate_30d = []
    @link_clicks_rate_30d = @post_enagements_last_4w_data.zip(@link_clicks_last_4w_data).map { |x, y| (x / y.to_f).round(2) }
  
  end

  def googleanalytics

    @pageviews_week = GaDb.last(7).pluck(:pageviews_day).reduce(:+)
    @pageviews_month = GaDb.last(30).pluck(:pageviews_day).reduce(:+)

    @pageviews_last_7d = GaDb.last(7).pluck(:pageviews_day)
    @pageviews_last_30d = GaDb.last(30).pluck(:pageviews_day)

    @pageviews_week_rate = convert_percentrate(@pageviews_week, GaDb.last(14).first(7).pluck(:pageviews_day).reduce(:+))  
    @pageviews_month_rate = convert_percentrate(@pageviews_month, GaDb.last(60).first(30).pluck(:pageviews_day).reduce(:+))
    
    @pageviews_per_session_week = ((GaDb.last(7).pluck(:pageviews_per_session_day).reduce(:+))/7).round(2)
    @pageviews_per_session_month = ((GaDb.last(7).pluck(:pageviews_per_session_day).reduce(:+))/30).round(2)

    @pageviews_per_session_7d = GaDb.last(7).pluck(:pageviews_per_session_day).flat_map{|i|i.round(2)}
    @pageviews_per_session_30d = GaDb.last(30).pluck(:pageviews_per_session_day).flat_map{|i|i.round(2)}

    @pageviews_per_session_week_rate = convert_percentrate(@pageviews_per_session_week, (GaDb.last(14).first(7).pluck(:pageviews_per_session_day).reduce(:+)/7).round(2))  
    @pageviews_per_session_month_rate = convert_percentrate(@pageviews_per_session_month, (GaDb.last(60).first(30).pluck(:pageviews_per_session_day).reduce(:+)/30).round(2))  

    @avg_session_duration_week = ((GaDb.last(7).pluck(:avg_session_duration_day).reduce(:+))/7).round(2)
    @avg_session_duration_month = ((GaDb.last(30).pluck(:avg_session_duration_day).reduce(:+))/30).round(2)

    @avg_session_duration_7d = GaDb.last(7).pluck(:avg_session_duration_day).flat_map{|i|i.round(2)}
    @avg_session_duration_30d = GaDb.last(30).pluck(:avg_session_duration_day).flat_map{|i|i.round(2)}

    @avg_session_duration_week_rate = convert_percentrate(@avg_session_duration_week, (GaDb.last(14).first(7).pluck(:avg_session_duration_day).reduce(:+)/7).round(2))  
    @avg_session_duration_month_rate = convert_percentrate(@avg_session_duration_month, (GaDb.last(60).first(30).pluck(:avg_session_duration_day).reduce(:+)/30).round(2))  
    
    @user_age_bracket_month = [GaDb.last(30).pluck(:user_18_24).compact.reduce(:+), GaDb.last(30).pluck(:user_25_34).compact.reduce(:+), GaDb.last(30).pluck(:user_35_44).compact.reduce(:+), GaDb.last(30).pluck(:user_45_54).compact.reduce(:+), GaDb.last(30).pluck(:user_55_64).compact.reduce(:+), GaDb.last(30).pluck(:user_65).compact.reduce(:+)]
    
    @desktop = GaDb.last(30).pluck(:desktop_user).reduce(:+)
    @mobile = GaDb.last(30).pluck(:mobile_user).reduce(:+)
    @tablet = GaDb.last(30).pluck(:tablet_user).reduce(:+)

    @male_user = GaDb.last(30).pluck(:male_user).reduce(:+)
    @female_user = GaDb.last(30).pluck(:female_user).reduce(:+)

    @new_visitor = GaDb.last(30).pluck(:new_visitor).reduce(:+)
    @returning_visitor = GaDb.last(30).pluck(:return_visitor).reduce(:+)

  end

>>>>>>> ff65e6dcc40f03ec44ce2ed566ede8e7a732d628
  private

  def convert_percentrate(datanew,  dataold)
    return ((datanew - dataold) / dataold.to_f * 100).round(2)
  end

  def rate_transit(datanew, dataold)
    return ((datanew - dataold) / dataold.to_f * 10000).round(2)
  end

  def divide_date(date)
    date.split('T').first.split('-').join()[4..7].to_i 
  end

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

  def get_week_data(db, data)
    a = []
    a << db.last(22).pluck(:data)[22, 15]
    a << db.last(22).pluck(:data)[8, 1]
  end

  def fbinformation

    # facebook API
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    # facebook fans
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
<<<<<<< HEAD
    @fans_adds = @graph.get_object("278666028863859/insights/page_fan_adds_unique?fields=values&date_preset=last_30d")

    @fans_adds_week = @fans_adds.second['values'].flat_map{ |i|i.values.first }[29]
    @fans_adds_month = @fans_adds.third['values'].flat_map{ |i|i.values.first }[29]

    @fans_adds_last_7d = @fans_adds.first['values'].flat_map{ |i|i.values.first }[23..29]
    @fans_adds_last_30d = @fans_adds.first['values'].flat_map{ |i|i.values.first }

    @fans_adds_week_rate = (@fans_adds_week * 1000 / (@fans - @fans_adds_week).to_f).round(2)
    @fans_adds_month_rate = (@fans_adds_month * 1000 / (@fans - @fans_adds_month).to_f).round(2)
    
    # facebook page users
    @page_users_week = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").second.first.second.first['value'] 
    @page_users_month = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=today").third.first.second.first['value']     

    @page_users_week_last_week = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").second.first.second.first['value'] 
    @page_users_month_last_month = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").third.first.second.first['value']   

    @page_users_week_rate = (@page_users_week * 10 / @page_users_week_last_week.to_f).round(2)
    @page_users_month_rate = (@page_users_month * 10 / @page_users_month_last_month.to_f).round(2)

    @page_users_last_7d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_7d").first['values'].flat_map{ |i| i.values.first }
    @page_users_last_30d = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d").first['values'].flat_map{ |i| i.values.first }
    
    # facebook fans retention
    @page_impressions_last_7d_data = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_7d").first['values'].flat_map { |i| i.values.first } 
    @page_impressions_last_30d_data = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d").first['values'].flat_map { |i| i.values.first } 

    @fb_last_7d_date = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_7d").first['values'].flat_map{ |i| i.values.second }.map { |i| divide_date(i) }
    @fb_last_30d_date = @graph.get_object("278666028863859/insights/page_impressions?fields=values&date_preset=last_30d").first['values'].flat_map{ |i| i.values.second }.map{ |i| divide_date(i) }

    @post_enagements_last_7d_data = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_7d").first['values'].flat_map { |i| i.values.first }
    @post_enagements_last_30d_data = @graph.get_object("278666028863859/insights/page_post_engagements?fields=values&date_preset=last_30d").first['values'].flat_map { |i| i.values.first }

    @fans_retention_rate_7d = []
    @fans_retention_rate_7d = @post_enagements_last_7d_data.zip(@page_impressions_last_7d_data).map { |x, y| x / y.to_f }
    @fans_retention_rate_7d = @fans_retention_rate_7d.map{ |i| i.round(3) }

    @fans_retention_rate_30d = []
    @fans_retention_rate_30d = @post_enagements_last_30d_data.zip(@page_impressions_last_30d_data).map { |x, y| x / y.to_f }
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
    data[2].inner_text.to_i / 100.to_f
  end

  def rank(data)
    data[1].inner_text.delete(',').to_i
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

  def divide_date(date)
    date.split('T').first.split('-').join()[4..7].to_i 
  end

=======
    @fans_adds_week_data = FbDb.last(1).pluck(:fans_adds_week).first
    @fans_adds_month_data = FbDb.last(1).pluck(:fans_adds_month).first
    @fans_adds_week_last_week = FbDb.last(8).pluck(:fans_adds_week).first
    @fans_adds_month_last_month = FbDb.last(8).pluck(:fans_adds_week).first     
    @fans_adds_last_7d_data = FbDb.last(7).pluck(:fans_adds_day)
    @fans_adds_last_30d_data = FbDb.last(30).pluck(:fans_adds_day)
    @fans_adds_last_4w_data = FbDb.last(22).pluck(:fans_adds_week).values_at(0, 7, 14, 21)
    @fans_adds_week_rate = convert_percentrate(@fans_adds_week_data, @fans_adds_week_last_week)
    @fans_adds_month_rate = convert_percentrate(@fans_adds_month_data, @fans_adds_month_last_month)    
    # facebook page users
    #@pageusers = @graph.get_object("278666028863859/insights/page_impressions_unique?fields=values&date_preset=last_30d")
    @page_users_week = FbDb.last(1).pluck(:page_users_week).first
    @page_users_month = FbDb.last(1).pluck(:page_users_month).first   
    @page_users_week_last_week = FbDb.last(8).pluck(:page_users_week).first
    @page_users_month_last_month = FbDb.last(8).pluck(:page_users_month).first     
    @page_users_week_rate = convert_percentrate(@page_users_week, @page_users_week_last_week) 
    @page_users_month_rate = convert_percentrate(@page_users_month, @page_users_month_last_month)
    @page_users_last_7d = FbDb.last(7).pluck(:page_users_day)
    @page_users_last_30d = FbDb.last(30).pluck(:page_users_day)

    # facebook fans retention    
    #@postsusers = @graph.get_object("278666028863859/insights/page_posts_impressions_unique?fields=values&date_preset=last_30d")
    @posts_users_week = FbDb.last(1).pluck(:posts_users_week).first
    @posts_users_month = FbDb.last(1).pluck(:posts_users_month).first     
    @posts_users_week_last_week = FbDb.last(8).pluck(:posts_users_week).first
    @posts_users_month_last_month = FbDb.last(8).pluck(:posts_users_month).first     
    @posts_users_week_rate = convert_percentrate(@posts_users_week, @posts_users_week_last_week) 
    @posts_users_month_rate = convert_percentrate(@posts_users_month, @posts_users_month_last_month)
    @posts_users_last_7d = FbDb.last(7).pluck(:posts_users_day)
    @posts_users_last_30d = FbDb.last(30).pluck(:posts_users_day)
    @posts_users_last_7d_data = FbDb.last(7).pluck(:posts_users_day)
    @posts_users_last_4w_data = FbDb.last(22).pluck(:posts_users_week).values_at(0, 7, 14, 21)
    @fb_last_7d_date = FbDb.last(7).pluck(:date).map { |a| a.strftime("%m%d").to_i }
    @fb_last_4w_date = FbDb.last(22).pluck(:date).map { |a| a.strftime("%m%d").to_i }.values_at(0, 7, 14, 21)
    #@enagementsusers = @graph.get_object("278666028863859/insights/page_engaged_users?fields=values&date_preset=last_30d")
    @enagements_users_last_7d_data = FbDb.last(7).pluck(:enagements_users_day)
    @enagements_users_last_4w_data = FbDb.last(22).pluck(:enagements_users_week).values_at(0, 7, 14, 21)
    @fans_retention_rate_7d = []
    @fans_retention_rate_7d = @enagements_users_last_7d_data.zip(@posts_users_last_7d_data).map { |x, y| (x / y.to_f).round(2) }
    @fans_retention_rate_30d = []
    @fans_retention_rate_30d = @enagements_users_last_4w_data.zip(@posts_users_last_4w_data).map { |x, y| (x / y.to_f).round(2) }
  end

  def convert_tenthousandthrate(datanew,  dataold)
      return (datanew * 10000 / (dataold - datanew).to_f).round(2)
  end

  def ga_data_date
    first[1][0]["data"]["rows"].flat_map{|i|i.values.first}.grep(/\d+/, &:to_i)
  end
  
>>>>>>> ff65e6dcc40f03ec44ce2ed566ede8e7a732d628
end
