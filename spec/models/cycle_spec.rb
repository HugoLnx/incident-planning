require "spec_helper"

describe Cycle do
  describe "instance behavior" do
    describe "when updating the priorities that are already approved", focus: true do
      before :each do
        @cycle = create :cycle, priorities: "Priorities",
          priorities_approval_status: true
      end

      context "if changing to a new text" do
        it "lose the approval" do
          @cycle.update_priorities "New Priorities"
          expect(@cycle.priorities_approval_status).to be == false
        end
      end

      context "if maintaining the text" do
        it "maintain the priorities approval status" do
          @cycle.update_priorities "Priorities"
          expect(@cycle.priorities_approval_status).to be == true
        end
      end
    end

    describe "when approving all objectives at once" do
      before :each do
        @user = create :user_god
        @objectives = create_list(:objective, 3)
        @cycle = create :cycle,
          text_expressions: @objectives

        mock_expression_model approval_roles: [1, 2, 3]
      end

      it "approve all objectives of that cycle" do
        @cycle.approve_all_objectives(@user)

        expect(@objectives[0].status).to be == TextExpression::STATUS.approved
        expect(@objectives[1].status).to be == TextExpression::STATUS.approved
        expect(@objectives[2].status).to be == TextExpression::STATUS.approved
      end

      it "approve priorities of that cycle" do
        @cycle.approve_all_objectives(@user)

        expect(@cycle.priorities_approved?).to be == true
      end

      it "doesn't save approvals if cycle updating goes wrong" do
        InvalidSavingStubber.new(self).stub(@cycle)

        @cycle.approve_all_objectives(@user)

        expect(@objectives[0].status).to_not be_eql TextExpression::STATUS.approved
        expect(@objectives[1].status).to_not be_eql TextExpression::STATUS.approved
        expect(@objectives[2].status).to_not be_eql TextExpression::STATUS.approved
      end

      it "doesn't update cycle priorities status if any objective approval wasn't saved" do
        approval = Approval.new
        allow(Approval).to receive(:new) do |args|
          approval.attributes = args
          InvalidSavingStubber.new(self).stub(approval)
          approval
        end

        @cycle.approve_all_objectives(@user)

        expect(@cycle.priorities_approved?).to be == false
      end

      it "returns true when the approval was successful" do
        expect(@cycle.approve_all_objectives(@user)).to be == true
      end
    end


    describe "when checking if are approved" do
      context "is approved if all objectives and the priorities are already approved " do
        it "returns true if the cycle have three already approved objectives and the priorities approved" do
          objectives = create_list(:objective, 3)
          cycle = create :cycle,
            text_expressions: objectives,
            priorities_approval_status: true

          mock_expression_model approval_roles: [4]
          objectives.each{|obj| create :approval, role_id: 4, positive: true, expression: obj}

          expect(cycle).to be_approved
        end

        it "returns true if the cycle have priorities approved and three already approved objectives, and one strategy to be approved" do
          objectives = create_list(:objective, 3)
          cycle = create :cycle,
            text_expressions: objectives,
            priorities_approval_status: true

          create :strategy_how, cycle: cycle
          cycle.reload

          mock_expression_model approval_roles: [4]
          objectives.each{|obj| create :approval, role_id: 4, positive: true, expression: obj}

          expect(cycle).to be_approved
        end
      end

      context "isn't approved if any objectives are already approved" do
        it "returns false if the cycle have priorities approved, two already approved objectives, and one objective to be approved" do
          objectives = create_list(:objective, 3)
          cycle = create :cycle,
            text_expressions: objectives,
            priorities_approval_status: true


          mock_expression_model approval_roles: [4]
          objectives[0..-2].each{|obj| create :approval, role_id: 4, positive: true, expression: obj}

          expect(cycle).to_not be_approved
        end

        it "returns false if the cycle have priorities to be approved, and three approved objectives" do
          objectives = create_list(:objective, 3)
          cycle = create :cycle,
            text_expressions: objectives


          mock_expression_model approval_roles: [4]
          objectives.each{|obj| create :approval, role_id: 4, positive: true, expression: obj}

          expect(cycle).to_not be_approved
        end
      end
    end
  end

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
