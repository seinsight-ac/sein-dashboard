# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

env :PATH, ENV['PATH']
set :output, 'log/cron.log'

every 1.day, at: '10:00' do
  rake "grab_fb_data"
  rake "grab_ga_data"
  rake "grab_alexa_data"
end

every 5.day, at: '10:00' do
  rake "grab_mailchimp_data"
end