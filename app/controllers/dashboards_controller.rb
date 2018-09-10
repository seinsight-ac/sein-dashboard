class DashboardsController < ApplicationController

  before_action :authenticate_user!
  require 'google/apis/analyticsreporting_v4'
  require 'omniauth-google-oauth2'
  require 'json'

  def index 
  end
  
  def ga
    @data = GoogleAnalytics.ga_request(request) 
  end

  def mailchimp
    @campaigns = Mailchimp.campaigns('2018-08-01', '2018-09-01')
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