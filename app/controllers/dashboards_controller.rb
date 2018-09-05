class DashboardsController < ApplicationController
  require 'json'
  require 'gibbon'

  def index 
    @campaigns = Mailchimp.mailchimp_campaign
  end

end
