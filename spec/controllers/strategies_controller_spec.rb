require "spec_helper"

describe StrategiesController do
  shared_examples :success_expectations do
    it "respond with success" do
      expect(response).to be_success
    end

    it "render nothing" do
      expect(response.body).to be_blank
    end
  end

  describe "POST #create" do
    context "when reusing hierarchy" do
      let :current_cycle do
        create :cycle
      end

      before :each do
        config = build :reuse_configuration, hierarchy: true
        user = create :user, reuse_configuration: config
        sign_in user

        @strategy = create :strategy_group
        strategy_hierarchy = create_list :tactic_group, 3, father: @strategy
        @strategy.reload
        @how_reused = @strategy.text_expressions.first
        @father = create :objective_group

        post :create, 
          incident_id: current_cycle.incident_id,
          cycle_id: current_cycle.id,
          strategy: {
            how_reused: @how_reused.id,
            father_id: @father.id
          }
      end

      include_examples :success_expectations

      describe "strategy created" do
        let :strategy do
          assigns(:strategy)
        end

        it "have father_id equals passed by parameter" do
          expect(strategy.father_id).to be == @father.id
        end

        it "have hierarchy reused" do
          tactics_ids = @strategy.childs.map(&:text_expressions).flatten.map(&:id)
          reused_tactics_ids = strategy.childs.map(&:text_expressions).flatten.map(&:reused_expression_id)
          expect(reused_tactics_ids).to be == tactics_ids
        end

        describe "child named how" do
          let :how do
            strategy.text_expressions.first
          end

          it "have reused_expression_id equals how_reused passed by parameter" do
            expect(how.reused_expression_id).to be == @how_reused.id
          end
        end
      end
    end
  end
end
