class DashboardsController < ApplicationController

  def index 
    @report = Mailchimp.mailchimp_report
    @graph = User.last.facebook.get_object("me")
  end

end

require 'koala'