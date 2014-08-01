require 'spec_helper'

describe ExpressionSuggestionsController do
  render_views

  describe "GET #index" do
    shared_examples :success_expectations do
      it "respond with success" do
        expect(response).to be_success
      end
      it "render index" do
        expect(response).to render_template :index
      end
    end

    context "with default reuse configurations" do
      before :each do
        user = create :user
        sign_in user
      end

      context "getting suggestions to a new expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "TeSting How Exp"),
            create(:strategy_how, text: "test", reused: true),
            create(:strategy_how, text: "TEst")
          ]

          # non-suggested expressions
          create :strategy_how, text: "whatever text"
          create :tactic_who, text: "test"

          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1
        end

        it "filter the expressions by term and expression_name" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end

      context "getting suggestions to update an existent expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "TeSting How Exp"),
            create(:strategy_how, text: "test")
          ]

          # non-suggested expressions
          create :strategy_how, text: "whatever text"
          create :tactic_who, text: "test"
          to_be_updated = create :strategy_how, text: "TEst"
          
          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1,
            expression_updated_id: to_be_updated.id
        end

        it "filter the expressions by term and expression_name and excludes the expression that will be updated" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end
    end


    context "with reuse configuration filtering by incident" do
      before :each do
        @cycle_to_reuse = create :cycle
        config = build :reuse_configuration,
          incident_filter_type: ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:specific),
          incident_filter_value: @cycle_to_reuse.incident.id
        user = create :user, reuse_configuration: config
        sign_in user
        user_filter = create :user
      end

      context "getting suggestions to a new expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "TeSting How Exp", cycle: @cycle_to_reuse),
            create(:strategy_how, text: "test", cycle: @cycle_to_reuse)
          ]

          # non-suggested expressions
          create :strategy_how, text: "TEst"
          create :strategy_how, text: "whatever text"
          create :tactic_who, text: "test"

          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1
        end

        it "filter the expressions by term and expression_name" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end

      context "getting suggestions to update an existent expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "TeSting How Exp", cycle: @cycle_to_reuse)
          ]

          # non-suggested expressions
          create(:strategy_how, text: "test")
          create :strategy_how, text: "whatever text"
          create :tactic_who, text: "test"
          to_be_updated = create :strategy_how, text: "TEst", cycle: @cycle_to_reuse
          
          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1,
            expression_updated_id: to_be_updated.id
        end

        it "filter the expressions by term and expression_name and excludes the expression that will be updated" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end
    end

    context "with reuse configuration filtering by date" do
      before :each do
        @cycle_to_reuse = create :cycle
        config = build :reuse_configuration,
          date_filter: 6
        user = create :user, reuse_configuration: config
        sign_in user
        user_filter = create :user
      end

      let(:today) {DateTime.now.beginning_of_day}
      let(:one_month_ago) {today << 1}
      let(:six_months_ago) {today << 6}
      let(:six_months_and_one_day_ago) {((today << 6) - 1).end_of_day}
      let(:seven_months_ago) {today << 7}
      let(:twelve_months_ago) {today << 12}

      context "getting suggestions to a new expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "TEST", created_at: six_months_ago, cycle: @cycle_to_reuse),
            create(:strategy_how, text: "xTEstando", created_at: one_month_ago, cycle: @cycle_to_reuse),
            create(:strategy_how, text: "teStando", created_at: today, cycle: @cycle_to_reuse)
          ]

          # non-suggested expressions
          create(:strategy_how, text: "XXX", created_at: six_months_ago, cycle: @cycle_to_reuse)
          create :strategy_how, text: "testcc", created_at: six_months_and_one_day_ago, cycle: @cycle_to_reuse
          create :strategy_how, text: "testdd", created_at: seven_months_ago, cycle: @cycle_to_reuse
          create :strategy_how, text: "bbtest", created_at: twelve_months_ago, cycle: @cycle_to_reuse
          create :tactic_who, text: "testaa", created_at: today, cycle: @cycle_to_reuse

          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1
        end

        it "filter the expressions by term and expression_name" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end

      context "getting suggestions to update an existent expression" do
        before :each do
          @suggested_expressions = [
            create(:strategy_how, text: "xxTeStando", created_at: six_months_ago, cycle: @cycle_to_reuse),
            create(:strategy_how, text: "teStando", created_at: one_month_ago, cycle: @cycle_to_reuse)
          ]

          # non-suggested expressions
          create :strategy_how, text: "textoerrado", created_at: six_months_ago, cycle: @cycle_to_reuse
          create :strategy_how, text: "TESTando", created_at: six_months_and_one_day_ago, cycle: @cycle_to_reuse
          create :strategy_how, text: "teStando", created_at: seven_months_ago, cycle: @cycle_to_reuse
          create :strategy_how, text: "teStando", created_at: twelve_months_ago, cycle: @cycle_to_reuse
          create :tactic_who, text: "teStando", created_at: today, cycle: @cycle_to_reuse
          to_be_updated = create :strategy_how, text: "teStando", created_at: today, cycle: @cycle_to_reuse
 
          
          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1,
            expression_updated_id: to_be_updated.id
        end

        it "filter the expressions by term and expression_name and excludes the expression that will be updated" do
          expect(assigns(:expressions)).to be == @suggested_expressions
        end

        include_examples :success_expectations
      end
    end

    context "with reuse disabled", focus: true do
      before :each do
        @cycle_to_reuse = create :cycle
        config = build :reuse_configuration,
          enabled: false
        user = create :user, reuse_configuration: config
        sign_in user
        user_filter = create :user
      end

      context "getting suggestions to a new expression" do
        before :each do
          # non-suggested expressions
          create(:strategy_how, text: "TEST", cycle: @cycle_to_reuse)
          create(:strategy_how, text: "xTEstando", cycle: @cycle_to_reuse)
          create(:strategy_how, text: "teStando", cycle: @cycle_to_reuse)

          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1
        end

        it "filter the expressions by term and expression_name" do
          expect(assigns(:expressions)).to be_empty
        end

        include_examples :success_expectations
      end

      context "getting suggestions to update an existent expression" do
        before :each do
          # non-suggested expressions
          create(:strategy_how, text: "xxTeStando", cycle: @cycle_to_reuse)
          create(:strategy_how, text: "teStando", cycle: @cycle_to_reuse)
          create :strategy_how, text: "TESTando", cycle: @cycle_to_reuse
          to_be_updated = create :strategy_how, text: "teStando", cycle: @cycle_to_reuse
 
          
          get :index, format: :json,
            term: "test",
            expression_name: ::Model.strategy_how.name,
            incident_id: 1,
            expression_updated_id: to_be_updated.id
        end

        it "filter the expressions by term and expression_name and excludes the expression that will be updated" do
          expect(assigns(:expressions)).to be_empty
        end

        include_examples :success_expectations
      end
    end
  end
end
