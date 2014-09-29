class PdfNaming
  FORMAT = "[formname] OP[cycle]v[version] [date]([type])"
  ICS234 = "ICS-234"
  ICS202 = "ICS-202"
  TYPES = ::TypesLib::Enum.new %i{draft for_review final}
  TYPE_NAMES = {
    TYPES.name(:draft) => "Draft",
    TYPES.name(:for_review) => "For Review",
    TYPES.name(:final) => "Final"
  }

  def self.existent_version(version, **args)
    if version.final?
      type = :final
    else
      type = :for_review
    end
    PdfNaming.new(version.cycle, version.number, type: type, **args, date: version.created_at)
  end

  def self.draft(cycle, **args)
    PdfNaming.new(cycle, cycle.current_version_number, type: :draft, **args)
  end

  def initialize(cycle, version, type: TYPES.name(:draft), extension: false, date: DateTime.now)
    @cycle = cycle
    @version = version
    @type = type
    @extension = extension
    @date = date
  end

  def ics234
    name_to ICS234
  end

  def ics202
    name_to ICS202
  end

  def name_to(formname)
    name = FORMAT.gsub("[formname]", formname)
      .gsub("[type]", TYPE_NAMES[@type])
      .gsub("[cycle]", @cycle.number.to_s)
      .gsub("[version]", @version.to_s)
      .gsub("[date]", formatted_date)
    name += ".pdf" if @extension
    name
  end

private

  def formatted_date
    @date.strftime("%d-%m-%Y-%H-%M")
  end
end
