module ApplicationHelper

  def full_title(page_name = "")
    base_title = "修理管理票"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  def new_arrivals(created_at)
    text = "new"
    if created_at.since(2.day) > Time.now
      text
    end
  end

  def blank_text(text)
    if text.blank?
      "未登録"
    else
      text
    end
  end
end
