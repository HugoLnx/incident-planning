require "spec_helper"

describe Cycle do
  describe "module behaviors" do
    describe "when checking if next cycle of incident have mandatory 'from'" do
      it "returns true if the incident have previous cycles" do
        incident = create :incident
        create :cycle, incident: incident
        expect(Cycle.next_have_ending_mandatory?(incident)).to be == true
      end

      it "returns false if the incident haven't cycles" do
        incident = create :incident
        expect(Cycle.next_have_ending_mandatory?(incident)).to be == false
      end
    end

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

    describe "when getting the dates limits of the next cycle from an incident" do
      context "given the incident have no cycles" do
        it "the limits are now to 24h later" do
          allow(DateTime).to receive(:now).and_return(DateTime.new(2014, 1, 20, 20, 30))

          incident = create :incident

          dates_range = Cycle.next_dates_limits_to(incident)
          expect(dates_range.begin).to be == DateTime.new(2014, 1, 20, 20, 30)
          expect(dates_range.end).to be == DateTime.new(2014, 1, 21, 20, 30)
        end
      end

      context "given the incident have more then one cycle" do
        context "the next begin when the last cycle ends" do
          it "returns 20/01/2014 20:30 as beginning if incident have one cycle ending in 20/01/2014 20:30" do
            incident = create :incident
            create :cycle, incident: incident,
              to: DateTime.new(2014, 1, 20, 20, 30)

            dates_range = Cycle.next_dates_limits_to(incident)
            expect(dates_range.begin).to be == DateTime.new(2014, 1, 20, 20, 30)
          end
        end

        context "the next interval will be the same of the last cycle" do
          it "returns 20/01/2014 21:30 as ending if incident have one cycle ending in 20/01/2014 20:30 and beggining 1 hour before" do
            incident = create :incident
            create :cycle, incident: incident,
              from: DateTime.new(2014, 1, 20, 19, 30),
              to: DateTime.new(2014, 1, 20, 20, 30)

            dates_range = Cycle.next_dates_limits_to(incident)
            expect(dates_range.end).to be == DateTime.new(2014, 1, 20, 21, 30)
          end
        end
      end
    end
  end
end
