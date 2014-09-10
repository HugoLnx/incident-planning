require 'spec_helper'

describe Incident do
  context "given an instance" do
    before :each do
      @incident = build :incident
    end

    describe "when getting if is closed verifies if all child cycles are closed" do
      context 'if all cycles are closed' do
        it "is true" do
          @incident.cycles = build_list :cycle, 4, closed: true
          expect(@incident).to be_closed
        end
      end

      context "if any cycle isn't closed" do
        it "is false" do
          cycles = build_list :cycle, 4, closed: true
          cycles << build(:cycle, closed: false)
          @incident.cycles = cycles
          expect(@incident).to_not be_closed
        end
      end

      context "if have no cycles" do
        it "is false" do
          expect(@incident).to_not be_closed
        end
      end
    end
  end
end
