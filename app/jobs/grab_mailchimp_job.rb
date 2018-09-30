class GrabMailchimpJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = MailchimpDb.count

    before = (Date.today - 2)
    since = (Date.today - 7)

    campaigns = Mailchimp.campaigns(since.to_s, before.to_s)
    campaigns.reverse!
    set_mailchimp_db(campaigns)

    puts "add #{MailchimpDb.count - count} mailchimp data"
  end

  def set_mailchimp_db(campaigns)
    campaigns.each do |c|
      if c["send_time"].split('T').first != MailchimpDb.last.date.to_s.split(" ").first

        link = Mailchimp.click_details(c["id"])
        MailchimpDb.create(
          date: c["send_time"], 
          title: c["settings"]["subject_line"],
          email_sent: c["emails_sent"],
          open: c["report_summary"]["opens"],
          open_rate: c["report_summary"]["open_rate"],
          click: c["report_summary"]["subscriber_clicks"],
          click_rate: c["report_summary"]["click_rate"],
          most_click_title: link["url"],
          most_click_time: link["unique_clicks"]
          )
      end
    end
  end
end
