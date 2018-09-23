class ExportXls

  mattr_accessor :xls_report
  mattr_accessor :book
  mattr_accessor :head
  mattr_accessor :percent
  mattr_accessor :center
  mattr_accessor :left

  def initialize
    self.xls_report = StringIO.new
    self.book = Spreadsheet::Workbook.new 

    self.head = Spreadsheet::Format.new :pattern_fg_color => :orange, :vertical_align => :center, 
    :weight => :bold, :size => 14, :pattern => 1, :horizontal_align => :center, :height => 18
    self.percent = Spreadsheet::Format.new :number_format => '##.##%', :horizontal_align => :center
    self.center = Spreadsheet::Format.new :horizontal_align => :center, :vertical_align => :center
    self.left = Spreadsheet::Format.new :horizontal_align => :left, :vertical_align => :center


    @sheet1 = book.create_worksheet :name => "FB"
    @sheet1.default_format = center
    @sheet2 = book.create_worksheet :name => "GA"
    @sheet2.default_format = center
    @sheet3 = book.create_worksheet :name => "Mailchimp&Alexa"
    @sheet3.default_format = center
  end

  def ga_xls(date)

  end

  def fb_xls(data)

  end

  def mailchimp_xls(data)
    data = data.pluck(:date, :email_sent, :title, :open, :open_rate, :click, :most_click_title, :most_click_time)

    @sheet3.row(0).set_format(0, head)
    @sheet3[0, 0] = "電子報"
    @sheet3[1, 0] = "發佈日期"
    @sheet3[2, 0] = "訂閱數"
    @sheet3[3, 0] = "電子報標題"
    @sheet3.merge_cells(4, 0, 5, 0)
    @sheet3[4, 0] = "信件點開（次數/佔比）"
    @sheet3.merge_cells(6, 0, 7, 0)
    @sheet3[6, 0] = "連結點擊率（次數/佔比）"
    @sheet3.merge_cells(8, 0, 9, 0)
    @sheet3[8, 0] = "最多點擊文章（標題/次數）"
    @sheet3.column(0).width = 20

    i = 1
    data.each do |d|
      @sheet3.row(0).set_format(i, head)
      @sheet3[0, i] = "week#{i}"
      @sheet3[1, i] = d[0].strftime("%Y-%m-%d")
      @sheet3[2, i] = d[1]
      @sheet3.row(3).set_format(i, left)
      @sheet3[3, i] = d[2].split('】').second
      @sheet3[4, i] = d[3]
      @sheet3.row(5).set_format(i, percent)
      @sheet3[5, i] = d[4]
      @sheet3[6, i] = d[5]
      @sheet3.row(7).set_format(i, percent)
      @sheet3[7, i] = d[5] / d[3].to_f
      @sheet3.row(8).set_format(i, left)
      @sheet3[8, i] = d[6]
      @sheet3[9, i] = d[7]
      @sheet3.column(i).width = 20

      i += 1
    end
  end

  def alexa_xls(data)
    @sheet3.merge_cells(12, 0, 12, 5)
    @sheet3.row(12).set_format(0, head)
    @sheet3[12, 0] = "競爭媒體排名"

    @sheet3[13, 0] = "其他媒體"
    @sheet3[13, 1] = "網址"
    @sheet3[13, 2] = "國內排名"
    @sheet3[13, 3] = "跳出率"
    @sheet3[13, 4] = "每日每人瀏覽頁數"
    @sheet3[13, 5] = "每日每人停留時間"
    @sheet3.column(1).width = 20
    @sheet3.column(2).width = 20
    @sheet3.column(3).width = 20
    @sheet3.column(4).width = 20
    @sheet3.column(5).width = 20

    @sheet3[14, 0] = "社企流"
    @sheet3[15, 0] = "上下游"
    @sheet3[16, 0] = "泛科學"
    @sheet3[17, 0] = "環境資訊中心"
    @sheet3[18, 0] = "NPOst"
    @sheet3[19, 0] = "Womany"

    @sheet3[14, 1] = "http://www.seinsights.asia/"
    @sheet3[15, 1] = "http://www.newsmarket.com.tw/"
    @sheet3[16, 1] = "http://pansci.asia/"
    @sheet3[17, 1] = "http://e-info.org.tw/"
    @sheet3[18, 1] = "http://npost.tw/"
    @sheet3[19, 1] = "http://womany.net/"

    @sheet3[14, 2] = data.sein_rank
    @sheet3[15, 2] = data.newsmarket_rank
    @sheet3[16, 2] = data.pansci_rank
    @sheet3[17, 2] = data.einfo_rank
    @sheet3[18, 2] = data.npost_rank
    @sheet3[19, 2] = data.womany_rank

    @sheet3.row(14).set_format(3, percent)
    @sheet3[14, 3] = data.sein_bounce_rate
     @sheet3.row(15).set_format(3, percent)
    @sheet3[15, 3] = data.newsmarket_bounce_rate
     @sheet3.row(16).set_format(3, percent)
    @sheet3[16, 3] = data.pansci_bounce_rate
     @sheet3.row(17).set_format(3, percent)
    @sheet3[17, 3] = data.einfo_bounce_rate
     @sheet3.row(18).set_format(3, percent)
    @sheet3[18, 3] = data.npost_bounce_rate
     @sheet3.row(19).set_format(3, percent)
    @sheet3[19, 3] = data.womany_bounce_rate

    @sheet3[14, 4] = data.sein_pageview
    @sheet3[15, 4] = data.newsmarket_pageview
    @sheet3[16, 4] = data.pansci_pageview
    @sheet3[17, 4] = data.einfo_pageview
    @sheet3[18, 4] = data.npost_pageview
    @sheet3[19, 4] = data.womany_pageview

    @sheet3[14, 5] = "#{data.sein_on_site / 60}分#{data.sein_on_site % 60}秒"
    @sheet3[15, 5] = "#{data.newsmarket_on_site / 60}分#{data.newsmarket_on_site % 60}秒"
    @sheet3[16, 5] = "#{data.pansci_on_site / 60}分#{data.pansci_on_site % 60}秒"
    @sheet3[17, 5] = "#{data.einfo_on_site / 60}分#{data.einfo_on_site % 60}秒"
    @sheet3[18, 5] = "#{data.npost_on_site / 60}分#{data.npost_on_site % 60}秒"
    @sheet3[19, 5] = "#{data.womany_on_site / 60}分#{data.womany_on_site % 60}秒"
  end

  def export
    book.write xls_report
    xls_report.string
  end

end