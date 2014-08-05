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

      expect(form.objectives.to_a.sort).to be == cycle.text_expressions.load.to_a.sort
    end
  end

  context "when updating" do
    context "when already have three objectives" do
      before :each do
        objectives = [
          build(:objective, text: "Old Obj 1"),
          build(:objective, text: "Old Obj 2"),
          build(:objective, text: "Old Obj 3"),
        ]
        @old_owner = create :user

        @form = build :form202,
          objectives: objectives,
          owner: @old_owner
        @form.save
      end

      context "and updates the first two texts" do
        before :each do
          @new_owner = create :user
          @objectives = @form.objectives
          @form.update_with({
            owner: @new_owner,
            objectives_texts: {
              @objectives[0].id.to_s => "New Obj 1",
              @objectives[1].id.to_s => "New Obj 2",
              @objectives[2].id.to_s => "Old Obj 3"
            }
          })
          @saved = @form.save

          @objectives.each(&:reload)
        end

        it "maintain objectives instances" do
          expect(@form.objectives).to be == @objectives
        end

        it "update owner of first two objectives" do
          expect(@form.objectives[0].owner).to be == @new_owner
          expect(@form.objectives[1].owner).to be == @new_owner
        end

        it "doesn't change the owner of third objective" do
          expect(@form.objectives[2].owner).to be == @old_owner
        end

        it "update text of first two objectives" do
          expect(@form.objectives[0].text).to be == "New Obj 1"
          expect(@form.objectives[1].text).to be == "New Obj 2"
        end

        it "saves successfuly" do
          expect(@saved).to be == true
        end
      end

      context "and deletes the second objective" do
        before :each do
          new_owner = create :user
          @objectives = @form.objectives
          @form.update_with({
            owner: new_owner,
            objectives_texts: {
              @objectives[0].id.to_s => "Old Obj 1",
              @objectives[2].id.to_s => "Old Obj 3"
            }
          })
          @saved = @form.save

          @objectives.each{|obj| obj.reload if TextExpression.exists?(obj.id)}
        end

        it "maintain first and last references" do
          expect(@form.objectives[0]).to be == @objectives[0]
          expect(@form.objectives[1]).to be == @objectives[2]
        end

        it "destroy the second objective from database" do
          expect(TextExpression.exists?(@objectives[1].id)).to be == false
        end

        it "doesn't update any owner" do
          expect(@form.objectives[0].owner).to be == @old_owner
          expect(@form.objectives[1].owner).to be == @old_owner
        end

        it "saves successfuly" do
          expect(@saved).to be == true
        end
      end

      context "and creates two objectives" do
        before :each do
          @new_owner = create :user
          @objectives = @form.objectives
          @form.update_with({
            owner: @new_owner,
            objectives_texts: {
              @objectives[0].id.to_s => "Old Obj 1",
              @objectives[1].id.to_s => "Old Obj 2",
              @objectives[2].id.to_s => "Old Obj 3",
              "0" => [
                "New Obj 4",
                "New Obj 5"
              ]
            }
          })
          @saved = @form.save

          @objectives.each{|obj| obj.reload if TextExpression.exists?(obj.id)}
        end

        it "maintain old references" do
          expect(@form.objectives[0]).to be == @objectives[0]
          expect(@form.objectives[1]).to be == @objectives[1]
          expect(@form.objectives[2]).to be == @objectives[2]
        end

        it "doesn't update old owners" do
          expect(@form.objectives[0].owner).to be == @old_owner
          expect(@form.objectives[1].owner).to be == @old_owner
          expect(@form.objectives[2].owner).to be == @old_owner
        end

        it "saves successfuly" do
          expect(@saved).to be == true
        end

        describe "the two created objectives" do
          it "have the texts in '0' key" do
            expect(@form.objectives[3].text).to be == "New Obj 4"
            expect(@form.objectives[4].text).to be == "New Obj 5"
          end

          it "have the new owner" do
            expect(@form.objectives[3].owner).to be == @new_owner
            expect(@form.objectives[4].owner).to be == @new_owner
          end
        end
      end
    end

    context "other attributes" do
      it "re-set your attributes" do
        now = DateTime.now
        tomorrow = DateTime.now.days_since 1
        objectives = build_list :objective, 3

        form = build :form202

        form.update_with({
          from: now,
          to: tomorrow,
          number: 1,
          priorities: "hey priorities"
        })

        expect(form.from).to be == now
        expect(form.to).to be == tomorrow
        expect(form.number).to be == 1
        expect(form.priorities).to be == "hey priorities"
      end
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
      form = build :form202, objectives_texts: %W{obj1 obj2}

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

      expect(form.objectives_texts).to be == %W{obj1 obj2 obj3}
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

        expect(form.cycle.text_expressions.load.sort).to be == form.objectives.sort

        expect(form.objectives[0].cycle).to be == form.cycle
        expect(form.objectives[1].cycle).to be == form.cycle
        expect(form.objectives[2].cycle).to be == form.cycle
      end

      it "associate objectives with their owner" do
        objectives = 3.times.map{build(:objective)}
        form = build :form202, objectives: objectives
        form.save

        expect(form.objectives[0].owner).to be == form.owner
        expect(form.objectives[1].owner).to be == form.owner
        expect(form.objectives[2].owner).to be == form.owner
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
          raise ActiveRecord::RecordInvalid.new(objectives[1])
        end

        expect(form.save).to be_false
      end
    end
  end
end
