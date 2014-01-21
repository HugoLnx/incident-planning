require 'spec_helper'

describe Forms::Form202 do
  it_behaves_like "ActiveModel"

  context "when getting a cycle" do
    it "builds cycle based on your parameters" do
      now = DateTime.now
      tomorrow = DateTime.now.days_since 1

      form = build :form202,
        from: now,
        to: tomorrow,
        number: 1

      cycle = form.cycle
      expect(cycle.from).to be == now
      expect(cycle.to).to be == tomorrow
      expect(cycle.number).to be == 1
    end

    it "associates cycle to your incident" do
      incident = build :incident

      form = build :form202

      form.incident = incident

      expect(form.cycle.incident).to be == incident
    end
  end

  context "when saving" do
    context "if cycle is valid" do
      it "save the cycle" do
        form = build :form202

        expect(form.cycle).to receive(:save!).and_return(true)

        expect(form.save).to be_true
      end
    end

    context "if cycle is invalid" do
      it "does not save cycle" do
        form = build :form202

        expect(form.cycle).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(form.cycle)
        end

        expect(form.save).to be_false
      end
    end
  end
end
