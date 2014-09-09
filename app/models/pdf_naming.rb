class PdfNaming
  FORMAT = "[formname] ([prefix])C[cycle]v[version] [date]"
  ICS234 = "ICS-234"
  ICS202 = "ICS-202"
  TYPES = ::TypesLib::Enum.new %i{draft for_review final}
  TYPE_NAMES = {
    TYPES.name(:draft) => "Draft",
    TYPES.name(:for_review) => "For Review",
    TYPES.name(:final) => "Final"
  }

  def initialize(cycle, version, type: TYPES.name(:draft), extension: false)
    @cycle = cycle
    @version = version
    @type = type
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
      .gsub("[prefix]", TYPE_NAMES[@type])
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
