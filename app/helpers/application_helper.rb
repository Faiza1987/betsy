module ApplicationHelper
  def render_date(date)
    return "[unknown]" unless date
    return ("<span class='date' title='".html_safe + date.to_s + "'>".html_safe + time_ago_in_words(date) + " ago</span>".html_safe)
  end
end
