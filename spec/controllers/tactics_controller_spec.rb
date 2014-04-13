require 'spec_helper'

describe TacticsController do
  login_user

  let(:valid_date_str){"22/03/1993 10:30"}
  let(:valid_date){DateTime.strptime(valid_date_str, TimeExpression::TIME_PARSING_FORMAT)}
  let(:valid_expression_params){
    {
        who: "Who value",
        what: "What value",
        where: "Where value",
        when: valid_date_str,
        response_action: "RA value"
    }
  }

  describe "POST #create" do

    let(:valid_params) do
      father = create :strategy_group
      cycle = create :cycle, groups: [father]
      father.cycle = cycle
      father.save!

      tactic_params = valid_expression_params.merge({
        father_id: father.id
      })

      {
        tactic: tactic_params,
        cycle_id: cycle.id,
        incident_id: cycle.incident.id
      }
    end

    context "attribute 'when'" do
      it "create a new one if value was passed" do
        post :create, valid_params

        time_expression = TimeExpression.first
        expect(time_expression).not_to be nil
        expect(time_expression.when).to be == valid_date
      end
    end
  end

  describe "PUT #update" do
    context "attribute 'when'" do
      context "tactic have no 'when'" do
        before :each do
          @cycle = create :cycle
          @group = create :tactic_group,
            time_expressions: [],
            cycle: @cycle,
            father: create(:strategy_group)
          @cycle.groups << @group
        end

        let(:valid_params) do
          {
            tactic: valid_expression_params,
            cycle_id: @cycle.id,
            incident_id: @cycle.incident.id,
            id: @group.id
          }
        end

        it "create a new one if value was passed" do
          put :update, valid_params
          time_expression = TimeExpression.first
          expect(time_expression).not_to be nil
          expect(time_expression.when).to be == valid_date
        end

        it "doesn't create if no value was passed" do
          put :update, valid_params.merge({tactic: valid_expression_params.merge({when: ""})})
          time_expression = TimeExpression.first
          expect(time_expression).to be nil
        end
      end

      context "tactic have a 'when'" do
        before :each do
          @cycle = create :cycle
          @group = create :tactic_group,
            cycle: @cycle,
            father: create(:strategy_group)
          @cycle.groups << @group
        end

        let(:valid_params) do
          {
            tactic: valid_expression_params,
            cycle_id: @cycle.id,
            incident_id: @cycle.incident.id,
            id: @group.id
          }
        end

        it "update the existing one" do
          old_exp = @group.time_expressions.first
          put :update, valid_params
          @group.reload
          new_exp = @group.time_expressions.first
          expect(new_exp).to be == old_exp
          expect(new_exp.when).to be == valid_date
        end

        it "destroy the old if no value was passed" do
          old_exp = @group.time_expressions.first
          put :update, valid_params.merge({tactic: valid_expression_params.merge({when: ""})})
          @group.reload
          expect(@group.time_expressions.count).to be_zero
        end
      end
    end

  end
end
