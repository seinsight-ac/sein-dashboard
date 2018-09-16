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



  def self.webusersweek
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:7dayUsers" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: "7daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750"
      }]})
    @response = analytics.batch_get_reports(request)
    @webusersweek = JSON.parse(@response.to_json)  
  end

  def self.webusersmonth
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
    @webusersmonth = JSON.parse(@response.to_json)  
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

  def self.pageviews_7d
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: "7daysAgo", 
                           end_date: "today" }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @pageviews_7d = JSON.parse(@response.to_json)
  end

  

  def self.pageviews_30d
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today" }],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @pageviews_30d = JSON.parse(@response.to_json)
  end

  def self.session_pageviews_7d
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { view_id: "ga:55621750",
              page_size: 8,
              metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:sessionCount" }, { name: "ga:date" }],
             date_ranges: [{ start_date: "7daysAgo", 
                           end_date: "today" }]
                  
      }]})
    @response = analytics.batch_get_reports(request)
    @session_pageviews_7d = JSON.parse(@response.to_json)
  end

  def self.session_pageviews_30d
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { view_id: "ga:55621750",
              page_size: 31,
              metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:sessionCount" }, { name: "ga:date" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today" }]
                  
      }]})
    @response = analytics.batch_get_reports(request)
    @session_pageviews_30d = JSON.parse(@response.to_json)
  end

  def self.session_pageviews_month
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:sessionCount" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today" }],
             view_id: "ga:55621750", 
             pageSize: 8
            
      }]})
    @response = analytics.batch_get_reports(request)
    @session_pageviews_month = JSON.parse(@response.to_json)
  end

  def self.channel_grouping_week
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }, { expression: "ga:bounceRate" }],
             dimensions: [{ name: "ga:channelGrouping"}],
             date_ranges: [{ start_date: "7daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @channel_goruping_week = JSON.parse(@response.to_json)
  end


  def self.channel_grouping_month
    analytics = AnalyticsReportingService.new  
    analytics.authorization = @credentials
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }, { expression: "ga:bounceRate" }],
             dimensions: [{ name: "ga:channelGrouping"}],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750" 
      }]})
    @response = analytics.batch_get_reports(request)
    @channel_goruping_month = JSON.parse(@response.to_json)
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
