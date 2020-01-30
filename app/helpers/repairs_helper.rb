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

  # 修理完了日表示 date_fieldにて完了日が空の場合は今日の日付を表示する
  def date_text(completed_day)
    if completed_day.blank?
      Date.today
    else
      completed_day.to_date
    end
  end
end
