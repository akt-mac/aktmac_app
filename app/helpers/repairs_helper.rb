module RepairsHelper

  # 受付番号表示
  def format_reception_number(integer)
    if integer.present?
      format('%06d', integer.to_i)
    end
  end

  # 進捗状況表示
  def progress_text(progress)
    if progress == 1
      "未完了"
    elsif progress == 2
      "✔"
    else
      "未登録"
    end
  end
end
