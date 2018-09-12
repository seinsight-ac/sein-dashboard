require 'google/apis/analyticsreporting_v4'
require 'omniauth-google-oauth2'
require 'json'

class GoogleAnalytics
    


  def self.active_user(google_token)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new  
    analytics.authorization = google_token
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:30dayUsers"}],
             dimensions:[{name:"ga:date"}],
             date_ranges:[{start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
      }]})
    @response = analytics.batch_get_reports(request)
    @active_user = JSON.parse(@response.to_json)  
  end

  def self.avg_session_duration(google_token)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new  
    analytics.authorization = google_token
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:avgSessionDuration"}],
             dimensions:[{name:"ga:date"}],
             date_ranges:[{start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
      }]})
    @response = analytics.batch_get_reports(request)
    @avg_session_duration = JSON.parse(@response.to_json)  
  end

  def self.pageviews_per_session(google_token)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new  
    analytics.authorization = google_token
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:pageviewsPerSession"}],
             dimensions:[{name:"ga:date"}],
             date_ranges:[{start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
      }]})
    @response = analytics.batch_get_reports(request)
    @pageviews_per_session = JSON.parse(@response.to_json)  
  end

  def self.session_count(google_token)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new  
    analytics.authorization = google_token
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:users"}],
             dimensions:[{name:"ga:sessionCount"}],
             date_ranges:[{start_date: (Date.today - 30).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
      }]})
    @response = analytics.batch_get_reports(request)
    @session_count = JSON.parse(@response.to_json)
  end

end
