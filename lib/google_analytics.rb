require 'google/apis/analyticsreporting_v4'
require 'omniauth-google-oauth2'
require 'json'

class GoogleAnalytics

  def self.ga_request(request)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    @creds = ServiceAccountCredentials.make_creds(
      {:json_key_io => File.open('client_secrets.json'),:scope => SCOPE})
    analytics.authorization = @creds
    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      {report_requests:[
            {metrics:[{expression: "ga:pageviews"}, 
                      {expression: "ga:pageviewsPerSession"},
                      {expression: "ga:avgSessionDuration"},
                      {expression: "ga:bounceRate"},
                      {expression: "ga:sessions"},
                      {expression: "ga:percentNewSessions"}],
             dimensions:[{name:"ga:date"},
                         {name:"ga:channelGrouping"},
                         {name:"ga:daysSinceLastSession"}],
             date_ranges:[{start_date: (Date.today - 7).strftime("%Y-%m-%d"), 
                           end_date: Time.now.strftime("%Y-%m-%d")}],
             view_id:"ga:55621750", 
      }]})
    @response = analytics.batch_get_reports(request)
    @data = JSON.parse(@response.to_json) 
  end

end
