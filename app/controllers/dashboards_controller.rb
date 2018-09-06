class DashboardsController < ApplicationController

  def index 
    @report = Mailchimp.mailchimp_report
    @graph = User.last.facebook.get_object("278666028863859/insights/page_content_activity/day")
    binding.pry
  end

end

require 'koala'