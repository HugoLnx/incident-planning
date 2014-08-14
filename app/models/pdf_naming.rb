class PdfNaming
  FORMAT = "[formname] [draft]C[cycle]v[version] [date]"
  ICS234 = "ICS-234"
  ICS202 = "ICS-202"

  def initialize(cycle, version, draft: false, extension: false)
    @cycle = cycle
    @version = version
    @draft = draft
    @extension = extension
  end

  def ics234
    name_to ICS234
  end

  def ics202
    name_to ICS202
  end

  def name_to(formname)
    name = FORMAT.gsub("[formname]", formname)
      .gsub("[draft]", (@draft ? "(Draft) " : ""))
      .gsub("[cycle]", @cycle.number.to_s)
      .gsub("[version]", @version.to_s)
      .gsub("[date]", formatted_date)
    name += ".pdf" if @extension
    name
  end

private

  def formatted_date
    DateTime.now.strftime("%Y-%d-%m")
  end
end
