require 'google/apis/analyticsreporting_v4'
require "googleauth"

class GoogleAnalytics

  include Google::Apis::AnalyticsreportingV4


  @credentials = 
    Google::Auth::UserRefreshCredentials.new(
      client_id: CONFIG.GOOGLE_API_KEY,
      client_secret: CONFIG.GOOGLE_API_SECRET,
      scope: ["https://www.googleapis.com/auth/analytics.readonly"],
      additional_parameters: { "access_type" => "offline" })
    
  @credentials.refresh_token = "1/dUKaaIMt-JkRe5ZloWOw5VIYiDiEGYENBnX7LquTJPMq8EBEEwaNVwE-9iqCIo3u"
  @credentials.fetch_access_token!



  def self.active_user
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:30dayUsers" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: (Date.today - 30).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750"
      }]})
    @response = analytics.batch_get_reports(request)
    @active_user = JSON.parse(@response.to_json)  
  end

  def self.avg_session_duration
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:avgSessionDuration" }],
             dimensions: [ { name: "ga:date" }],
             date_ranges: [ { start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @avg_session_duration = JSON.parse(@response.to_json)  
  end

  def self.pageviews_per_session
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:pageviewsPerSession" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @pageviews_per_session = JSON.parse(@response.to_json)  
  end

  def self.session_count
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }],
             dimensions: [{ name: "ga:sessionCount" }],
             date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @session_count = JSON.parse(@response.to_json)
  end

  def self.channel_grouping
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }, { expression: "ga:bounceRate" }],
             dimensions: [{ name: "ga:channelGrouping"}],
             date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @channel_goruping = JSON.parse(@response.to_json)
  end

  def self.user_type
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }],
             dimensions: [{ name: "ga:userType" }],
             date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @user_type = JSON.parse(@response.to_json)
  end

  def self.device
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }],
             dimensions: [{ name: "ga:deviceCategory" }],
             date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @device = JSON.parse(@response.to_json)
  end

end
