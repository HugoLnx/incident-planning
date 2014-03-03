module ApplicationHelper
  def cycle_closed_name(is_closed)
    is_closed ? "closed" : "open"
  end

  def format_date(date)
    return "" if date.nil?
    date.strftime "%d/%m/%Y %H:%M"
  end
end
