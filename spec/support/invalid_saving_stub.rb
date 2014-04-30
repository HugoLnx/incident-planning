class InvalidSavingStubber
  def initialize(example)
    @example = example
  end

  def stub(record)
    @example.allow(record).to @example.receive(:save).and_return(false)

    @example.allow(record).to @example.receive(:save!) do
      raise ActiveRecord::RecordInvalid.new(record)
    end

    @example.allow(record).to @example.receive(:update).and_return(false)

    @example.allow(record).to @example.receive(:update!) do
      raise ActiveRecord::RecordInvalid.new(record)
    end
  end

  def stub_all(records)
    records.each{|r| stub(r)}
  end
end
