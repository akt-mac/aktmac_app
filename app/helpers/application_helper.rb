module ApplicationHelper

  def full_title(page_name = "")
    base_title = "修理管理票"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  # 登録から2日以内はnewマークを表示
  # def new_arrivals(created_at)
  #   text = "new"
  #   if created_at.since(1.day) > Time.now
  #     text
  #   end
  # end

  # 値が無い場合は未登録表示
  def blank_text(text)
    if text.blank?
      "―"
    else
      text
    end
  end
end
