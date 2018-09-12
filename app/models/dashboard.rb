class Dashboard < ApplicationRecord

  def self.to_csv
    title = %w{ title subject_line send_time emails_sent }
    CSV.generate(headers: true) do |csv|
      csv << title

      all.each do |campaign|
        data = %w{ campaign["settings"]["title"] 
          campaign["setting"]["subject_line"]
          campaign["send_time"]
          campaign["emails_sent"]}
        csv << data
      end
    end
  end

end
