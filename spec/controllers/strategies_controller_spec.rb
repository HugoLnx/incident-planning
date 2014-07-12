require "spec_helper"

describe StrategiesController do
  let :current_cycle do
    create :cycle
  end

  let :current_incident do
    current_cycle.incident
  end

  shared_examples :success_expectations do
    it "respond with success" do
      expect(response).to be_success
    end

    it "render nothing" do
      expect(response.body).to be_blank
    end
  end

  shared_examples :reuse_creating_a_new_hierarchy do
    describe "the strategy" do
      it "have hierarchy reused" do
        tactics_ids = @strategy.childs.map(&:text_expressions).flatten.map(&:id)
        reused_tactics_ids = strategy.childs.map(&:text_expressions).flatten.map(&:reused_expression_id)
        expect(reused_tactics_ids).to be == tactics_ids
      end

      describe "the child named how" do
        it "have reused_expression_id equals how_reused passed by parameter" do
          expect(how.reused_expression_id).to be == @how_reused.id
        end
      end
    end
  end

  describe "POST #create" do
    context "when reusing hierarchy" do
      let :strategy do
        assigns(:strategy)
      end

      let :how do
        strategy.text_expressions.first
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
          incident_id: current_incident.id,
          cycle_id: current_cycle.id,
          strategy: {
            how_reused: @how_reused.id,
            father_id: @father.id
          }
      end

      include_examples :success_expectations
      include_examples :reuse_creating_a_new_hierarchy

      it "the strategy created have father_id equals passed by parameter" do
        expect(strategy.father_id).to be == @father.id
      end
    end
  end

  describe "PUT #update with reuse configuration turned on" do
    let :strategy do
      @strategy_to_update.reload
      @strategy_to_update
    end

    let :how do
      strategy.text_expressions.first
    end

    before :each do
      config = build :reuse_configuration, hierarchy: true
      user = create :user, reuse_configuration: config
      sign_in user
    end

    context "when updated strategy have childs and doesn't reuse other" do
      let :strategy do
        @strategy_to_update.reload
        @strategy_to_update
      end

      let :how do
        strategy.text_expressions.first
      end

      before :each do
        @strategy_to_update = create(:strategy_group)
        @old_hierarchy = create_list :tactic_group, 3, father: @strategy_to_update
        @strategy_to_update.reload

        put :update, id: @strategy_to_update.id,
          incident_id: current_incident.id,
          cycle_id: current_cycle.id,
          strategy: {
            how: "New how text",
          }
      end

      it "updates the how text" do
        expect(how.text).to be == "New how text"
      end

      it "maintain the same hierarchy" do
        expect(strategy.childs).to be == @old_hierarchy
      end
    end

    context "when updated strategy haven't childs and reuse strategy that has" do
      before :each do
        @strategy = create :strategy_group
        strategy_hierarchy = create_list :tactic_group, 3, father: @strategy
        @strategy.reload
        @how_reused = @strategy.text_expressions.first
        @strategy_to_update = create(:strategy_group)

        put :update, id: @strategy_to_update.id,
          incident_id: current_incident.id,
          cycle_id: current_cycle.id,
          strategy: {
            how: @how_reused.text,
            how_reused: @how_reused.id
          }
      end

      include_examples :success_expectations
      include_examples :reuse_creating_a_new_hierarchy
    end

    context "when reuse strategy that has childs" do
      before :each do
        @strategy = create :strategy_group
        strategy_hierarchy = create_list :tactic_group, 3, father: @strategy
        @strategy.reload
        @how_reused = @strategy.text_expressions.first
      end

      context "and updated strategy has too" do
        before :each do
          @strategy_to_update = create(:strategy_group)
          @old_hierarchy = create_list :tactic_group, 3, father: @strategy_to_update
          @strategy_to_update.reload

          put :update, id: @strategy_to_update.id,
            incident_id: current_incident.id,
            cycle_id: current_cycle.id,
            strategy: {
              how: @how_reused.text,
              how_reused: @how_reused.id
            }
        end

        include_examples :success_expectations
        include_examples :reuse_creating_a_new_hierarchy

        it "delete old hierarchy of updated strategy" do
          expect(Group.exists?(@old_hierarchy[0].id)).to be == false
          expect(Group.exists?(@old_hierarchy[1].id)).to be == false
          expect(Group.exists?(@old_hierarchy[2].id)).to be == false
        end
      end
    end
  end
end
