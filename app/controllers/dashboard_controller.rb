class DashboardController < ApplicationController

  def index 
    @report = get_mailchimp_report
  end

end
