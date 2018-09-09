module DashboardsHelper
  def show_data(website)
    website.each do |data|
      if data["country"] == 158 
        "visits: #{data["visits"].round(2)}" 
        content_tag(:br)
        "pages_per_visit: #{data["pages_per_visit"].round(2)}"
        content_tag(:br)
        "average_time: #{data["average_time"].round(2)}"
        content_tag(:br)
        "bounce_rate: #{(data["bounce_rate"] * 100).round(2)}"
        content_tag(:br)
        "rank: #{data["rank"]}"
      end
    end
  end
end
