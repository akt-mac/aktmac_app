class RepairPDF < Prawn::Document

  def initialize(repair)
    super()

    font "vendor/fonts/ipaexm.ttf"
    text "秋田マッカラー　PDF表示テスト"
  end
end
