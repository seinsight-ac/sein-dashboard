class DashboardsController < ApplicationController

  def index 
    @report = Mailchimp.mailchimp_report
  end

end
