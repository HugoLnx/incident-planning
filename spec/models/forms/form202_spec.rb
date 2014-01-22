require 'spec_helper'

describe Forms::Form202 do
  it_behaves_like "ActiveModel"

  context "when building from a cycle" do
    it "set your attributes from cycle" do
      now = DateTime.now
      tomorrow = DateTime.now.days_since 1

      cycle = build :cycle,
        from: now,
        to: tomorrow,
        number: 1,
        priorities: "hey priorities"
      
      form = Forms::Form202.new_from(cycle)

      expect(form.from).to be == cycle.from
      expect(form.to).to be == cycle.to
      expect(form.number).to be == cycle.number
      expect(form.priorities).to be == cycle.priorities
    end

    it "set your objectives from cycles objectives" do
      cycle = create :cycle,
        text_expressions: create_list(:objective, 3)

      form = Forms::Form202.new_from(cycle)

      expect(form.objectives.to_a).to be == cycle.text_expressions.load.to_a
    end
  end

  context "when updating" do
    it "re-set your attributes" do
      now = DateTime.now
      tomorrow = DateTime.now.days_since 1
      objectives = build_list :objective, 3

      form = build :form202

      form.update_with({
        from: now,
        to: tomorrow,
        number: 1,
        priorities: "hey priorities",
        objectives: objectives
      })

      expect(form.from).to be == now
      expect(form.to).to be == tomorrow
      expect(form.number).to be == 1
      expect(form.priorities).to be == "hey priorities"
      expect(form.objectives).to be == objectives
    end
  end

  context "when check if is persisted" do
    it "verifies if your cycle is persisted" do
      form = build :form202

      expect(form.cycle).to receive(:persisted?)

      form.persisted?
    end
  end

  context "when receives new objectives as text" do
    it "builds text expressions based on the lines of objectives text" do
      form = build :form202, objectives_text: %Q{obj1\nobj2}

      expect(form.objectives[0].text).to be == "obj1"
      expect(form.objectives[1].text).to be == "obj2"
    end
  end

  context "when parse objectives to text" do
    it "each text expression becomes a line in the text" do
      form = build :form202, objectives: [
        build(:objective, text: "obj1"),
        build(:objective, text: "obj2"),
        build(:objective, text: "obj3")
      ]

      expect(form.objectives_text).to be == %Q{obj1\nobj2\nobj3}
    end
  end

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
