module CyclesHelper
  def objectives_text_input(form, form202)
    form.input :objectives_text,
      as: :text,
      label:"Objectives (One per line)",
      disabled: form202.persisted?,
      input_html: {cols: 100, rows: 10}
  end
end
