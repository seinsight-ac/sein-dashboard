class ExportXls

  mattr_accessor :xls_report
  mattr_accessor :book
  mattr_accessor :head

  def initialize
    self.xls_report = StringIO.new
    self.book = Spreadsheet::Workbook.new 

    self.head = Spreadsheet::Format.new :pattern_fg_color => :orange, 
    :weight => :bold, :size => 14, :pattern => 1, :horizontal_align => :center
    @center = Spreadsheet::Format.new :horizontal_align => :center
    @percent = Spreadsheet::Format.new :number_format => '##.##%', :horizontal_align => :center

    @sheet1 = book.create_worksheet :name => "dashboard"
    @sheet1.default_format = @center
  end

  def ga_xls(date)

  end

  def fb_xls(data)

  end

  def mailchimp_xls(data)
    @sheet1.row(0).default_format = head

    @sheet1.row(0).concat %w[電子報]
    title =  %w[發佈日期 訂閱數 電子報標題 
      信件點開次數 信件點開佔比 連結點擊率次數 連結點擊率佔比 
      最多點擊文章標題 最多點擊文章次數]

    count = 1
    title.each do |t|
      @sheet1[count, 0] = t
      count += 1
    end

    count_column = 1
    data.each do |campaign|
      @sheet1[0, count_column] = campaign["settings"]["title"]
      @sheet1[1, count_column] = campaign["send_time"].split('T').first
      @sheet1[2, count_column] = campaign["emails_sent"]
      @sheet1[3, count_column] = campaign["settings"]["subject_line"].split('】').second
      @sheet1[4, count_column] = campaign["report_summary"]["opens"]
      @sheet1.row(5).set_format(count_column, @percent)
      @sheet1[5, count_column] = campaign["report_summary"]["open_rate"]
      @sheet1[6, count_column] = campaign["report_summary"]["subscriber_clicks"]
      @sheet1.row(7).set_format(count_column, @percent) 
      @sheet1[7, count_column] = campaign["report_summary"]["click_rate"]

      url = Mailchimp.click_details(campaign["id"])
      @sheet1[8, count_column] = url["url"]
      @sheet1[9, count_column] = url["unique_clicks"]
      count_column += 1
    end
  end

  def alexa_xls(a, b, c, d, e,f)
    @sheet1.row(10).default_format = head
    @sheet1.merge_cells(10, 0, 10, 5)
    @sheet1[10, 0] = "競爭媒體排名"
    @sheet1.row(11).concat %w[其他媒體 網址 國內排名 跳出率 每日每人瀏覽頁數 每日每人停留時間]
    @sheet1[12, 0] = "社企流"
    @sheet1[13, 0] = "上下游"
    @sheet1[14, 0] = "泛科學"
    @sheet1[15, 0] = "環境資訊中心"
    @sheet1[16, 0] = "NPOst"
    @sheet1[17, 0] = "Womany"

    @sheet1[12, 1] = "http://www.seinsights.asia/"
    @sheet1[13, 1] = "http://www.newsmarket.com.tw/"
    @sheet1[14, 1] = "http://pansci.asia/"
    @sheet1[15, 1] = "http://e-info.org.tw/"
    @sheet1[16, 1] = "http://npost.tw/"
    @sheet1[17, 1] = "http://womany.net/"

    row_count = 12
    [a, b, c, d, e, f].each do |data|
      @sheet1[row_count, 2] = data[1].inner_text.gsub(/\n/, "")
      @sheet1[row_count, 3] = data[2].inner_text.gsub(/\n/, "")
      @sheet1[row_count, 4] = data[3].inner_text.gsub(/\n/, "")
      @sheet1[row_count, 5] = data[4].inner_text.gsub(/\n/, "")
      row_count += 1
    end
  end

  def export
    book.write xls_report
    xls_report.string
  end

end