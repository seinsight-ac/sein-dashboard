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

  # def fb
  #   require 'koala'
  #   @graph = Koala::Facebook::API.new(CONFIG.FB_TOKEN)
  #   @fans = @graph.get_object("278666028863859/insights/page_fans")
  # end
  
  def alexa
    @sein = Alexa.data('seinsights.asia')
    @newsmarket = Alexa.data("newsmarket.com.tw")
    @pansci = Alexa.data("pansci.asia")
    @einfo = Alexa.data("e-info.org.tw")
    @npost = Alexa.data("npost.tw")
    @womany = Alexa.data("womany.net")
  end 
end
