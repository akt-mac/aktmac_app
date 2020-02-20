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
      "未"
    elsif progress == 2
      "✔"
    else
      "未登録"
    end
  end

  # 催促表示
  def reminder_text(reminder)
    if reminder == 1
      "―"
    elsif reminder == 2
      "✔"
    else
      "未登録"
    end
  end

  # 修理完了日表示 date_fieldにて完了日が空の場合は今日の日付を表示する
  def date_text(completed_day)
    if completed_day.blank?
      Date.today
    else
      completed_day.to_date
    end
  end

  # 完了した項目に「済」を表示
  def sumi_text(complete)
    if complete == 2
      "済"
    end
  end

  # 範囲検索結果flashメッセージの"～"の表示
  def from_to_text(from, to)
    if from.present? || to.present?
      "～"
    end
  end
end
