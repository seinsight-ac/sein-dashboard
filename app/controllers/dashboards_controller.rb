class DashboardsController < ApplicationController
<<<<<<< HEAD
  before_action :authenticate_user!
  require 'google/apis/analyticsreporting_v4'
  require 'omniauth-google-oauth2'
=======
  require 'json'

>>>>>>> b7eaa6b144a1f9b98716003757d4c01d247b3b4a

  def index 
  end
  
  def ga
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = current_user.google_token
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:pageviews"}, {expression: "ga:pageviewsPerSession"}, {expression: "ga:avgSessionDuration"}, {expression: "ga:bounceRate"}, {expression: "ga:sessions"}, {expression: "ga:percentNewSessions"}],
             dimensions:[{name:"ga:date"}, {name:"ga:channelGrouping"}, {name:"ga:daysSinceLastSession"}],
             date_ranges:[{start_date: (Date.today - 7).strftime("%Y-%m-%d"), end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
    }]})
    @response = analytics.batch_get_reports(request)
    @data = JSON.parse(@response.to_json) 
  end

<<<<<<< HEAD
=======
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
  
>>>>>>> b7eaa6b144a1f9b98716003757d4c01d247b3b4a
end

