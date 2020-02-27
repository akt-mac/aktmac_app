class RepairPDF < Prawn::Document
  include ApplicationHelper
  include RepairsHelper

  def initialize(repair, date)
    super(page_size: 'A4', page_layout: :landscape)
    @repairs_pdf = repair
    @date = date
    font "vendor/fonts/ipaexm.ttf"
    stroke_axis
    header
    table_content
  end

  def header
    y_position = cursor - 0

    # bounding_boxで記載箇所を指定して、textメソッドでテキストを記載
    bounding_box([0, 500, y_position], width: 270, height: 20) do
      font_size 10.5
      draw_text "修理一覧", size: 25, at: [0, 20]
      draw_text "印刷日:  #{Date.current.strftime("%Y年%-m月%d日")}", at: [620, 20]
    end
  end

  def table_content
    table repair_rows do
      cells.size = 6 # 文字サイズ
      cells.padding = 3 # セルのpadding幅
      cells.borders = [:top, :bottom, :right, :left] # 表示するボーダーの向き(top, bottom, right, leftがある)
      cells.border_width = 0.1 # ボーダーの太さ

      # 個別設定
      # row(0)は0行目、row(1)は1行目、row(-1)は最後の行、row(-2)は最後から2行目を表す
      row(0).border_width = 0.5
      columns(0).align = :right
      columns(1).align = :right
      columns(2).align = :center
      columns(3).align = :right
      row(0).align = :center
      # row(-2).border_width = 1.5
      # row(-1).background_color = "cdd3e2"
      # row(-1).borders = []

      self.header     = true  # 1行目をヘッダーとするか否か
      self.row_colors = ['f5f5f5', 'ffffff'] # 列の色
      self.column_widths = [25, 25, 20, 35, 90, 40, 40, 40, 115, 115, 120, 50, 50] # 列の幅
    end
  end

  def repair_rows
    arr = [["受付日", "完了日", "引渡", "受付番号", "得意先名", "型式", "カテゴリ", "修理者", "症状", "備考", "住所", "電話", "携帯"]]

    # テーブルのデータ部
    @repairs_pdf.each do |r, item|
      item.each do |i|
        if i.reception_day&.strftime("%Y%m") == @date
          arr << [i.reception_day.try(:strftime, "%-m/%-d"),
                  i.completed.try(:strftime, "%-m/%-d"),
                  sumi_text(i.delivery),
                  blank_text(format_reception_number(i.reception_number)),
                  i.customer_name,
                  i.machine_model,
                  i.category,
                  i.repair_staff,
                  i.condition,
                  i.note,
                  i.address,
                  i.phone_number,
                  i.mobile_phone_number]
        end
      end
    end
    return arr
  end
end
