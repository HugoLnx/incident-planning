module CyclesHelper
  RESOURCE_NAME = "Incident Objectives (ICS 202)"

  def objectives_text_input(form, form202)
    form.input :objectives_text,
      as: :text,
      label:"Objectives (One per line)",
      disabled: form202.persisted?,
      input_html: {cols: 100, rows: 10}
  end

  def resource_name
    RESOURCE_NAME
  end
end
