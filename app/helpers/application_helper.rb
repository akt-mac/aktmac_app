module ApplicationHelper

  def full_title(page_name = "")
    base_title = "修理管理票"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  # 値が無い場合は未登録表示
  def blank_text(text)
    if text.blank?
      "―"
    else
      text
    end
  end

  # btn文字数幅合わせ
  def text_space(text)
    "&nbsp;&nbsp;&nbsp;&nbsp;#{text}&nbsp;&nbsp;&nbsp;&nbsp;".html_safe
  end
end
