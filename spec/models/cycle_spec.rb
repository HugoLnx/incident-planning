require "spec_helper"

describe Cycle do
  describe "when getting the number of the next cycle from incident" do
    context "considers the number autoincrementable" do
      it "returns 1 if incident have no cycles" do
        incident = create :incident
        expect(Cycle.next_number_to(incident)).to be == 1
      end

      it "returns 2 if incident have 1 cycle" do
        incident = create :incident
        create :cycle, incident: incident
        expect(Cycle.next_number_to(incident)).to be == 2
      end
    end
  end
end
