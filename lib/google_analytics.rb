require 'google/apis/analyticsreporting_v4'
require "googleauth"

class GoogleAnalytics

  include Google::Apis::AnalyticsreportingV4

  mattr_accessor :credentials
  mattr_accessor :analytics

  def initialize(since, before)
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
    @since = since
    @before = before
  end

  def users
    request_simple("ga:users")
  end

  def users_7
    request_simple("ga:7dayUsers")
  end

  def users_30
    request_simple("ga:30dayUsers")
  end

  def bounce
    request_simple("ga:bounceRate")
  end

  def pageview
    request_simple("ga:pageviews")
  end

  def session
    request_simple("ga:sessions")
  end

  def user_type
    request_two_dim("ga:users", "ga:userType")
  end

  def channel(token = 0)
    request_two("ga:users", "ga:bounceRate", "ga:channelGrouping", token)
  end

  def avg_session
    request_simple("ga:avgSessionDuration")
  end

  def avg_time_page
    request_simple("ga:avgTimeOnPage")
  end

  def bracket(token = 0)
    request_two_dim("ga:users", "ga:userAgeBracket", token)
  end

  def gender(token = 0)
    request_two_dim("ga:users", "ga:userGender", token)
  end

  def page_per_session
    request_simple("ga:pageviewsPerSession")
  end

  def device(token = 0)
    request_two_dim("ga:users", "ga:deviceCategory", token)
  end

  private


  def request_simple(metrics, token = 0)
    request = GetReportsRequest.new(
      { report_requests: [{
        view_id: "ga:55621750",
        metrics: [
          {
            expression: "#{metrics}"
          }
        ],dimensions:[
          {
            name: "ga:date"
          }
        ],date_ranges:[
          {
            start_date: @since,
            end_date: @before
          }
        ],page_token: "#{token}"
      }]})
    return convert(request)
  end


  def request_two_dim(metrics, dimensions, token = 0)
    request = GetReportsRequest.new(
      { report_requests: [{
        view_id: "ga:55621750",
        metrics: [
          {
            expression: "#{metrics}"
          }
        ],dimensions:[
          {
            name: "ga:date"
          },{
            name: "#{dimensions}"
          }
        ],date_ranges:[
          {
            start_date: @since,
            end_date: @before
          }
        ],page_token: "#{token}"
      }]})
    return convert(request)
  end


  def request_two(metrics1, metrics2, dimensions, token = 0)
    request = GetReportsRequest.new(
      { report_requests: [{
        view_id: "ga:55621750",
        metrics: [
          {
            expression: "#{metrics1}"
          },{
            expression: "#{metrics2}"
          }
        ],dimensions:[
          {
            name: "ga:date"
          },{
            name: "#{dimensions}"
          }
        ],date_ranges:[
          {
            start_date: @since,
            end_date: @before
          }
        ],page_token: "#{token}"
      }]})
    return convert(request)
  end

  def convert(request)
    response = analytics.batch_get_reports(request)
    JSON.parse(response.to_json)["reports"][0]["data"]["rows"]
  end

end
