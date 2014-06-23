require 'spec_helper'

describe ExpressionSuggestionsController do
  render_views

  describe "GET #index" do
    before :each do
      user = create :user
      sign_in user
    end

    context "getting suggestions to a new expression" do
      it "filter the expressions by term and expression_name" do
        suggested_expressions = [
          create(:strategy_how, text: "TeSting How Exp"),
          create(:strategy_how, text: "test"),
          create(:strategy_how, text: "TEst")
        ]

        # non-suggested expressions
        create :strategy_how, text: "whatever text"
        create :tactic_who, text: "test"
        
        get :index, format: :json,
          term: "test",
          expression_name: ::Model.strategy_how.name,
          incident_id: 1

        expect(assigns(:expressions)).to be == suggested_expressions
        expect(response).to be_success
        expect(response).to render_template :index
      end
    end

    context "getting suggestions to update an existent expression" do
      it "filter the expressions by term and expression_name and excludes the expression that will be updated" do
        suggested_expressions = [
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

        expect(assigns(:expressions)).to be == suggested_expressions
        expect(response).to be_success
        expect(response).to render_template :index
      end
    end
  end
end
