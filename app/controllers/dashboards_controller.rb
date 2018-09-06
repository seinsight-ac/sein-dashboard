class DashboardsController < ApplicationController


  def index 
    @report = Mailchimp.mailchimp_report
    @graph = User.last.facebook.get_object("278666028863859/insights/page_content_activity/day")
    binding.pry
  end

  def ga
    require 'google/apis/analyticsreporting_v4'

    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = current_user.google_token

    date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '7DaysAgo', end_date: 'today')
    metric = Google::Apis::AnalyticsreportingV4::Metric.new(expression: 'ga:sessions', alias: 'sessions')
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:browser')
    
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: '55621750',
      metrics: [metric],
      dimensions: [dimension],
      date_ranges: [date_range]
      )]
    ) 
    @response = analytics.batch_get_reports(request)
    @response.reports
    render json: {
      data: @response
    }
    
  end


end

require 'koala'