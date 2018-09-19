require 'google/apis/analyticsreporting_v4'
require "googleauth"

class GoogleAnalytics

  include Google::Apis::AnalyticsreportingV4

  mattr_accessor :credentials
  mattr_accessor :analytics

  def initialize
    self.credentials = 
      Google::Auth::UserRefreshCredentials.new(
      client_id: CONFIG.GOOGLE_API_KEY,
      client_secret: CONFIG.GOOGLE_API_SECRET,
      scope: ["https://www.googleapis.com/auth/analytics.readonly"],
      additional_parameters: { "access_type" => "offline" })

    self.credentials.refresh_token = CONFIG.GOOGLE_REFRESH_TOKEN
    self.credentials.fetch_access_token!

    self.analytics = AnalyticsReportingService.new
    self.analytics.authorization = self.credentials
  end

  def web_users_week
    
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:7dayUsers" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750"
      }]})
    return convert(request)

  end

  def web_users_month

    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:30dayUsers" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: (Date.today - 30).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d") }],
             view_id: "ga:55621750"
      }]})

    return convert(request)

  end

  # def avg_session_duration
  #   request = GetReportsRequest.new(
  #     { report_requests: [
  #           { metrics: [{ expression: "ga:avgSessionDuration" }],
  #            dimensions: [ { name: "ga:date" }],
  #            date_ranges: [ { start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
  #                          end_date: Time.now.strftime("%Y-%m-%d") }],
  #            view_id: "ga:55621750" 
  #     }]})
  #   return convert(request) 
  # end

  # def pageviews_per_session
  #   request = GetReportsRequest.new(
  #     { report_requests: [
  #           { metrics: [{ expression: "ga:pageviewsPerSession" }],
  #            dimensions: [{ name: "ga:date" }],
  #            date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
  #                          end_date: Time.now.strftime("%Y-%m-%d") }],
  #            view_id: "ga:55621750" 
  #     }]})
  #   return convert(request)
  # end



  def pageviews
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:date" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today" }],
             view_id: "ga:55621750" 
      }]})
    return convert(request)
  end


  def session_pageviews
    request = GetReportsRequest.new(
      { report_requests: [
            { view_id: "ga:55621750",
              page_size: 31,
              metrics: [{ expression: "ga:pageviews" }],
             dimensions: [{ name: "ga:sessionCount" }, { name: "ga:date" }],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today" }]
                  
      }]})
    return convert(request)
  end

  

  def channel_grouping_week
    
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }, { expression: "ga:bounceRate" }],
             dimensions: [{ name: "ga:channelGrouping"}],
             date_ranges: [{ start_date: "7daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750" 
      }]})
    return convert(request)
  end

  def channel_grouping_month
    request = GetReportsRequest.new(
      { report_requests: [
            { metrics: [{ expression: "ga:users" }, { expression: "ga:bounceRate" }],
             dimensions: [{ name: "ga:channelGrouping"}],
             date_ranges: [{ start_date: "30daysAgo", 
                           end_date: "today"}],
             view_id: "ga:55621750" 
      }]})
    return convert(request)
  end

  # def user_type
  #   request = GetReportsRequest.new(
  #     { report_requests: [
  #           { metrics: [{ expression: "ga:users" }],
  #            dimensions: [{ name: "ga:userType" }],
  #            date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
  #                          end_date: Time.now.strftime("%Y-%m-%d") }],
  #            view_id: "ga:55621750" 
  #     }]})
  #   return convert(request)
  # end

  # def device
  #   request = GetReportsRequest.new(
  #     { report_requests: [
  #       { metrics: [{ expression: "ga:users" }],
  #        dimensions: [{ name: "ga:deviceCategory" }],
  #        date_ranges: [{ start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
  #                      end_date: Time.now.strftime("%Y-%m-%d") }],
  #        view_id: "ga:55621750" 
  #     }]})
  #   return convert(request)
  # end

  private

  def convert(request)
    response = analytics.batch_get_reports(request)
    JSON.parse(response.to_json)
  end

end
