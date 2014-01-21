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
        number: 1,
        priorities: "hey priorities"

      cycle = form.cycle
      expect(cycle.from).to be == now
      expect(cycle.to).to be == tomorrow
      expect(cycle.number).to be == 1
      expect(cycle.priorities).to be == "hey priorities"
    end

    it "associates cycle to your incident" do
      incident = build :incident

      form = build :form202

      form.incident = incident

      expect(form.cycle.incident).to be == incident
    end
  end

  context "when saving" do
    context "if cycle and objectives are valid" do
      it "save the cycle" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives

        expect(form.cycle).to receive(:save!)

        form.save
      end

      it "returns true" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives

        expect(form.save).to be_true
      end

      it "save the objectives" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives

        expect(objectives[0]).to receive(:save!)
        expect(objectives[1]).to receive(:save!)
        expect(objectives[2]).to receive(:save!)

        form.save
      end

      it "associates with your objectives" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives

        form.save

        expect(form.cycle.text_expressions.load).to be == form.objectives

        expect(form.objectives[0].cycle).to be == form.cycle
        expect(form.objectives[1].cycle).to be == form.cycle
        expect(form.objectives[2].cycle).to be == form.cycle
      end
    end

    context "if cycle is invalid" do
      it "does not save nothing" do
        form = build :form202

        allow(form.cycle).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(form.cycle)
        end

        expect(form.save).to be_false
      end
    end

    context "if one objective is invalid" do
      it "does not save nothing" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives

        allow(objectives[1]).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(form.cycle)
        end

        expect(form.save).to be_false
      end
    end
  end
end
