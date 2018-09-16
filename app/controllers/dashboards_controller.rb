class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def ga
    ga = GoogleAnalytics.new
    @active_user = ga.active_user
    @avg_session_duration = ga.avg_session_duration
    @pageviews_per_session = ga.pageviews_per_session
    @session_count = ga.session_count
    @single_session_user = @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @multi_session_user = @session_count.first[1][0]["data"]["totals"][0]["values"][0].to_i - @session_count.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0].to_i
    @channel_grouping = ga.channel_grouping
    @channel_user = @channel_grouping.first[1][0]["data"]["totals"][0]["values"][0]
    @user_type = ga.user_type
    @vistor = @user_type.first[1][0]["data"]["totals"][0]["values"][0]
    @new = @user_type.first[1][0]["data"]["rows"][0]["metrics"][0]["values"][0]
    @old = @user_type.first[1][0]["data"]["rows"][1]["metrics"][0]["values"][0]
    @device = ga.device
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
    
    # alexa
    @womanyrank = Alexa.data("womany.net")[1].inner_text.delete(',').to_i
    @panscirank = Alexa.data("pansci.asia")[1].inner_text.delete(',').to_i
    @newsmarketrank = Alexa.data("newsmarket.com.tw")[1].inner_text.delete(',').to_i
    @einforank = Alexa.data("e-info.org.tw")[1].inner_text.delete(',').to_i
    @seinrank = Alexa.data('seinsights.asia')[1].inner_text.delete(',').to_i
    @npostrank = Alexa.data("npost.tw")[1].inner_text.delete(',').to_i
    @womanyrate = divide100(Alexa.data("womany.net")[2].inner_text.to_i)
    @panscirate = divide100(Alexa.data("pansci.asia")[2].inner_text.to_i)
    @newsmarketrate = divide100(Alexa.data("newsmarket.com.tw")[2].inner_text.to_i)
    @einforate = divide100(Alexa.data("e-info.org.tw")[2].inner_text.to_i)
    @seinrate = divide100(Alexa.data('seinsights.asia')[2].inner_text.to_i)
    @npostrate = divide100(Alexa.data("npost.tw")[2].inner_text.to_i)
  end

  
  def alexa
    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")
  end

  def divide100(data)
    return data/100.to_f
  end
  
end
