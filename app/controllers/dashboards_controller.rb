class DashboardsController < ApplicationController
  before_action :authenticate_user!
  require 'json'

  # def ga
  #   require 'google/apis/analyticsreporting_v4'

  #   analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
  #   analytics.authorization = current_user.google_token

  #   date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '7DaysAgo', end_date: 'today')
  #   metric = Google::Apis::AnalyticsreportingV4::Metric.new(expression: 'ga:sessions', alias: 'sessions')
  #   dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:browser')
    
  #   request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
  #     report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
  #     view_id: '55621750',
  #     metrics: [metric],
  #     dimensions: [dimension],
  #     date_ranges: [date_range]
  #     )]
  #   ) 
  #   @response = analytics.batch_get_reports(request)
  #   @response.reports
  #   render json: {
  #     data: @response
  #   }
    
  # end

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
