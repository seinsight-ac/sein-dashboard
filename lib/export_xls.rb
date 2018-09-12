class ExportXls

  mattr_accessor :xls_report
  mattr_accessor :book
  mattr_accessor :head

  def initialize
    self.xls_report = StringIO.new
    self.book = Spreadsheet::Workbook.new
    self.head = Spreadsheet::Format.new :pattern_fg_color => :orange, 
    :weight => :bold, :size => 14, :pattern => 1
    @percent_format = Spreadsheet::Format.new :number_format => '##.##%'
  end

  def mailchimp_xls(data)
    sheet1 = book.create_worksheet :name => "mailchimp"
    sheet1.row(0).default_format = head

    sheet1.row(0).concat %w[電子報]
    title =  %w[發佈日期 訂閱數 電子報標題 
      信件點開次數 信件點開佔比 連結點擊率次數 連結點擊率佔比 
      最多點擊文章標題 最多點擊文章次數]

    count = 1
    title.each do |t|
      sheet1[count, 0] = t
      count += 1
    end

    count_column = 1
    data.each do |campaign|
      sheet1[0, count_column] = campaign["settings"]["title"]
      sheet1[1, count_column] = campaign["send_time"].split('T').first
      sheet1[2, count_column] = campaign["emails_sent"]
      sheet1[3, count_column] = campaign["settings"]["subject_line"].split('】').second
      sheet1[4, count_column] = campaign["report_summary"]["opens"]
      sheet1.row(5).set_format(count_column, @percent_format)
      sheet1[5, count_column] = campaign["report_summary"]["open_rate"]
      sheet1[6, count_column] = campaign["report_summary"]["subscriber_clicks"]
      sheet1.row(7).set_format(count_column, @percent_format) 
      sheet1[7, count_column] = campaign["report_summary"]["click_rate"]

      url = Mailchimp.click_details(campaign["id"])
      sheet1[8, count_column] = url["url"]
      sheet1[9, count_column] = url["unique_clicks"]
      count_column += 1
    end

    book.write xls_report
    xls_report.string
  end


end