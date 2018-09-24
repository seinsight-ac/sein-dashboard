class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :fbinformation, :only => [:index, :facebook]
  before_action :index, :only => [:googleanalytics]

  def index
    # google
    @web_users_week = GaDb.last(7).pluck(:web_users_week).reduce(:+)
    @web_users_month = GaDb.last(30).pluck(:web_users_week).reduce(:+)

    @web_users_last_7d = GaDb.last(7).pluck(:web_users_week)
    @web_users_last_30d = GaDb.last(30).pluck(:web_users_week)
    
    @web_users_week_rate = convert_percentrate(@web_users_week, GaDb.last(14).first(7).pluck(:web_users_week).reduce(:+))  
    @web_users_month_rate = convert_percentrate(@web_users_month, GaDb.last(60).first(30).pluck(:web_users_week).reduce(:+))

    @all_users_views_last_7d_data = GaDb.last(7).pluck(:pageviews_day)
    @all_users_views_last_4w_data = [GaDb.last(7).pluck(:pageviews_day).reduce(:+), GaDb.last(14).first(7).pluck(:pageviews_day).reduce(:+), GaDb.last(21).first(7).pluck(:pageviews_day).reduce(:+), GaDb.last(28).first(7).pluck(:pageviews_day).reduce(:+)]

    @single_session_pageviews_7d = GaDb.last(7).pluck(:single_session)
    @single_session_pageviews_4w = [GaDb.last(7).pluck(:single_session).reduce(:+), GaDb.last(14).first(7).pluck(:single_session).reduce(:+), GaDb.last(21).first(7).pluck(:single_session).reduce(:+), GaDb.last(28).first(7).pluck(:single_session).reduce(:+)]

    @activeusers_views_last_7d_data = @all_users_views_last_7d_data.zip(@single_session_pageviews_7d).map{|k| (k[0] - k[1]) }
    @activeusers_views_last_4w_data = @all_users_views_last_4w_data.zip(@single_session_pageviews_4w).map{|k| (k[0] - k[1]) }
    
    @users_activity_rate_7d = @activeusers_views_last_7d_data.zip(@all_users_views_last_7d_data).map{|k| (k[0] / k[1].to_f).round(2) }
    @users_activity_rate_4w = @activeusers_views_last_4w_data.zip(@all_users_views_last_4w_data).map{|k| (k[0] / k[1].to_f).round(2) }
    
    @ga_last_7d_date = GaDb.last(7).pluck(:date).map { |a| a.strftime("%m%d").to_i }
    @ga_last_4w_date = GaDb.last(30).pluck(:date).map { |a| a.strftime("%m%d").to_i }.values_at(8, 15, 22, 29)

    @channel_user_week = [GaDb.last(7).pluck(:oganic_search_day).compact.reduce(:+), GaDb.last(7).pluck(:social_user_day).compact.reduce(:+), GaDb.last(7).pluck(:direct_user_day).compact.reduce(:+), GaDb.last(7).pluck(:referral_user_day).compact.reduce(:+), GaDb.last(7).pluck(:email_user_day).compact.reduce(:+)]
    @bounce_rate_week = [(GaDb.last(7).pluck(:oganic_search_bounce).compact.reduce(:+)/7).round(2), (GaDb.last(7).pluck(:social_bounce).compact.reduce(:+)/7).round(2), (GaDb.last(7).pluck(:direct_bounce).compact.reduce(:+)/7).round(2), (GaDb.last(7).pluck(:referral_bounce).compact.reduce(:+)/7).round(2), (GaDb.last(7).pluck(:email_bounce).compact.reduce(:+)/GaDb.last(7).pluck(:email_bounce).compact.size).round(2)]
    @channel_user_month = [GaDb.last(30).pluck(:oganic_search_day).compact.reduce(:+), GaDb.last(30).pluck(:social_user_day).compact.reduce(:+), GaDb.last(30).pluck(:direct_user_day).compact.reduce(:+), GaDb.last(30).pluck(:referral_user_day).compact.reduce(:+), GaDb.last(30).pluck(:email_user_day).compact.reduce(:+)]
    @bounce_rate_month = [(GaDb.last(30).pluck(:oganic_search_bounce).compact.reduce(:+)/30).round(2), (GaDb.last(30).pluck(:social_bounce).compact.reduce(:+)/30).round(2), (GaDb.last(30).pluck(:direct_bounce).compact.reduce(:+)/30).round(2), (GaDb.last(30).pluck(:referral_bounce).compact.reduce(:+)/30).round(2), (GaDb.last(30).pluck(:email_bounce).compact.reduce(:+)/GaDb.last(30).pluck(:email_bounce).compact.size).round(2)]
    

    # mailchimp
    @mail_users = MailchimpDb.last.email_sent
    @mail_users_month_rate = convert_percentrate(MailchimpDb.last(4).first.email_sent - @mail_users, MailchimpDb.last(12).first.email_sent - MailchimpDb.last(8).first.email_sent)

    @last_12w_date = MailchimpDb.last(4).pluck(:date).map { |a| a.strftime("%m%d").to_i }
    @mail_users_last_30d = MailchimpDb.last(4).pluck(:email_sent)

    @mail_views = MailchimpDb.last(4).pluck(:open)
    @mail_links= MailchimpDb.last(4).pluck(:click)

    @mail_views_rate = MailchimpDb.last(4).pluck(:open_rate).map { |a| a.round(2)}

    @mail_links_rate = []
    @mail_links.zip(@mail_views) { |a, b| @mail_links_rate << (a / b.to_f).round(2) }

    # alexa
    @rank = AlexaDb.last(1).pluck(:womany_rank, :pansci_rank, :newsmarket_rank, :einfo_rank, :sein_rank, :npost_rank)[0]
    @rate = AlexaDb.last(1).pluck(:womany_bounce_rate, :pansci_bounce_rate, :newsmarket_bounce_rate, :einfo_bounce_rate, :sein_bounce_rate, :npost_bounce_rate)[0].map { |a| a.round(2)}
    @created_at = AlexaDb.last.created_at.strftime("%Y-%m-%d")

    
    # export to xls
    export_xls = ExportXls.new
    
    #export_xls.mailchimp_xls(@campaigns)
    #export_xls.alexa_xls(@sein, @newsmarket, @pansci, @einfo, @npost, @womany)
    
    respond_to do |format|
      format.xls { send_data(export_xls.export,
        :type => "text/excel; charset=utf-8; header=present",
        :filename => "社企流資料分析.xls")
      }
      format.html
    end
  end

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
    @link_clicks_rate_7d = @link_clicks_last_7d_data.zip(@post_enagements_last_7d_data).map { |x, y| (x / y.to_f).round(2) }
    @link_clicks_rate_30d = []
    @link_clicks_rate_30d = @link_clicks_last_4w_data.zip(@post_enagements_last_4w_data).map { |x, y| (x / y.to_f).round(2) }
  
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

  def excel
    last_month_mon

    fb = FbDb.where("date >= ? AND date <= ?", @last, @end)
    ga = GaDb.where("date >= ? AND date <= ?", @last, @end)
    mailchimp = MailchimpDb.where("date >= ? AND date <= ?", @last, @end)
    alexa = AlexaDb.last

    export_xls = ExportXls.new
    
    export_xls.fb_xls(fb)
    export_xls.ga_xls(ga)
    export_xls.mailchimp_xls(mailchimp)
    export_xls.alexa_xls(alexa)
    
    respond_to do |format|
      format.xls { send_data(export_xls.export,
        :type => "text/excel; charset=utf-8; header=present",
        :filename => "社企流#{(Date.today << 1).strftime("%m")[1]}月資料分析.xls")
      }
      format.html
    end
  end

  def create
    @starttime = params[:starttime]
    @endtime = params[:endtime]
    puts @starttime
    pust @endtime
  end

  private

  def convert_percentrate(datanew,  dataold)
    return ((datanew - dataold) / dataold.abs.to_f * 100).round(2)
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
    @end = (@last + 28).strftime("%Y-%m-%d")
    @last = @last.strftime("%Y-%m-%d") # 格式2018-08-18
  end

  def fbinformation

    # facebook API
    @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
    # facebook fans
    @fans = @graph.get_object("278666028863859/insights/page_fans?fields=values&date_preset=today").first.first.second.first["value"]
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
  
end
