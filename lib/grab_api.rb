require 'sidekiq-scheduler'

class GrabApi
  include Sidekiq::Worker

  def perform
    GrabFbJob.perform_now
    GrabGaJob.perform_now
    GrabMailchimpJob.perform_now
    GrabAlexaJob.perform_now
  end
end