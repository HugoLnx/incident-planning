module DateTimeBrFactory
  def self.build(day, month, year, hour, minute)
    DateTime.new(year, month, day, hour, minute)
  end
end
