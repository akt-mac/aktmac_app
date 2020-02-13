class RepairPDF < Prawn::Document

  def initialize(repair)
    super(page_size: 'A4', page_layout: :landscape)
    @repair = repair
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
      cells.padding = 5         # セルのpadding幅
      cells.borders = [:bottom,] # 表示するボーダーの向き(top, bottom, right, leftがある)
      cells.border_width = 0.5   # ボーダーの太さ

      # 個別設定
      # row(0) は0行目、row(-1) は最後の行を表す
      row(0).border_width = 1.5
      row(-2).border_width = 1.5
      row(-1).background_color = "cdd3e2"
      row(-1).borders = []

      self.header     = true  # 1行目をヘッダーとするか否か
      self.row_colors = ['dddddd', 'ffffff'] # 列の色
      self.column_widths = [50, 50, 50, 70, 70, 50, 70, 80, 80, 80, 50, 50] # 列の幅
    end
  end

  def repair_rows
    arr = [["受付日", "完了日", "修理者", "受付番号", "得意先名", "型式", "カテゴリ", "症状", "備考", "住所", "電話", "携帯"]]

    # テーブルのデータ部
  end
end
