module ApplicationHelper
  def cycle_closed_name(is_closed)
    is_closed ? "PUBLISHED" : "OPEN"
  end

  def cycle_approval_status_name(is_approved)
    is_approved ? "APPROVED" : "TO BE APPROVED"
  end

  def format_date(date)
    return "" if date.nil?
    date.strftime "%d/%m/%Y %H:%M"
  end

  def confirmation_form(subjects, opts={}, &block)
    if subjects.is_a? ActiveModel::Model
      subject = subjects
    else
      subject = subjects.last
    end

    opts[:confirm_only] ||= []

    have_to_confirm = (subject.persisted? && opts[:confirm_only].include?(:update)) ||
                      (!subject.persisted? && opts[:confirm_only].include?(:create))

    if have_to_confirm
      simple_form_for([@incident, @cycle], url: opts[:confirm_url], &block)
    else
      simple_form_for([@incident, @cycle], &block)
    end
  end

  def notify_errors(record)
    if record.errors.empty?
      return ""
    else
      render partial: "partials/form_errors",
        locals: {errors: record.errors}
    end
  end

  def btn_link_to(label, url, **options)
    btn_options = options.delete(:btn_options) || {}
    options[:method] ||= :get
    form_tag url, options do
      submit_tag label, btn_options
    end
  end

  def have_alarms
    %w{publishes versions}.include? controller_name
  end
end
