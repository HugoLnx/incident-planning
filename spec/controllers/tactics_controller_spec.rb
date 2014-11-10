require 'spec_helper'

describe TacticsController do
  login_user

  let(:valid_date_str){"22/03/1993 10:30"}
  let(:valid_date){Time.strptime(valid_date_str, TimeExpression::TIME_PARSING_FORMAT).to_datetime}
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
    before :each do
      @father = create :strategy_group
      @cycle = create :cycle, groups: [@father]
      @father.cycle = @cycle
      @father.save!
    end

    context "without reuse" do
      before :each do
        tactic_params = valid_expression_params.merge({
          father_id: @father.id
        })

        valid_params = {
          tactic: tactic_params,
          cycle_id: @cycle.id,
          incident_id: @cycle.incident.id
        }

        post :create, valid_params
      end

      shared_examples :all_expressions_expectations do
        it "is not nil" do
          expect(expression).not_to be nil
        end

        it "have owner that's current user" do
          expect(expression.owner).to be == subject.current_user
        end

        it "have reused equals false" do
          expect(expression).to_not be_reused
        end

        it "have source equals nil" do
          expect(expression.source).to be == nil
        end
      end

      describe "the when created" do
        let(:expression) {TimeExpression.first}

        include_examples :all_expressions_expectations

        it "have when that's parsed from string" do
          expect(expression.when).to be == valid_date
        end

        it "have text that's blank" do
          expect(expression.text).to be_blank
        end
      end

      describe "the who created" do
        let(:expression) {TextExpression.where(name: ::Model.tactic_who.name).first}

        include_examples :all_expressions_expectations

        it "have text equals passed as parameter" do
          expect(expression.text).to be == "Who value"
        end
      end

      describe "the what created" do
        let(:expression) {TextExpression.where(name: ::Model.tactic_what.name).first}

        include_examples :all_expressions_expectations

        it "have text equals passed as parameter" do
          expect(expression.text).to be == "What value"
        end
      end

      describe "the where created" do
        let(:expression) {TextExpression.where(name: ::Model.tactic_where.name).first}

        include_examples :all_expressions_expectations

        it "have text equals passed as parameter" do
          expect(expression.text).to be == "Where value"
        end
      end

      describe "the response_action created" do
        let(:expression) {TextExpression.where(name: ::Model.tactic_response_action.name).first}

        include_examples :all_expressions_expectations

        it "have text equals passed as parameter" do
          expect(expression.text).to be == "RA value"
        end
      end
    end

    context "using reuse in all expressions" do
      let(:reused_who){create(:tactic_who)}
      let(:reused_what){create(:tactic_what)}
      let(:reused_where){create(:tactic_where)}
      let(:reused_when){create(:tactic_when)}
      let(:reused_response_action){create(:tactic_response_action)}

      before :each do
        valid_params = {
          cycle_id: @cycle.id,
          incident_id: @cycle.incident.id,
          tactic: {
            who_reused: reused_who.id,
            what_reused: reused_what.id,
            where_reused: reused_where.id,
            when_reused: reused_when.id,
            response_action_reused: reused_response_action.id,
            father_id: @father.id
          }
        }

        old_expressions = TextExpression.all + TimeExpression.all

        post :create, valid_params

        @created_expressions = (TextExpression.all + TimeExpression.all) - old_expressions
      end

      shared_examples :all_expressions_expectations do
        it "is not nil" do
          expect(expression).not_to be nil
        end

        it "have owner that's current user" do
          expect(expression.owner).to be == subject.current_user
        end

        it "have reused equals true" do
          expect(expression).to be_reused
        end

        it "have source equals of reused expression" do
          expect(expression.source).to be == reused_expression.source
        end
      end

      shared_examples :text_expressions_expectations do
        it "have text equals of reused expression" do
          expect(expression.text).to be == reused_expression.text
        end
      end

      describe "the when created" do
        let(:reused_expression) {reused_when}
        let(:expression) {@created_expressions.find{|exp| exp.name == ::Model.tactic_when.name}}

        include_examples :all_expressions_expectations

        it "have when equals of reused expression" do
          expect(expression.when).to be == reused_expression.when
        end

        it "have text equals of reused expression" do
          expect(expression.text).to be == reused_expression.text
        end
      end

      describe "the who created" do
        let(:reused_expression) {reused_who}
        let(:expression) {@created_expressions.find{|exp| exp.name == ::Model.tactic_who.name}}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the what created" do
        let(:reused_expression) {reused_what}
        let(:expression) {@created_expressions.find{|exp| exp.name == ::Model.tactic_what.name}}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the where created" do
        let(:reused_expression) {reused_where}
        let(:expression) {@created_expressions.find{|exp| exp.name == ::Model.tactic_where.name}}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the response_action created" do
        let(:reused_expression) {reused_response_action}
        let(:expression) {@created_expressions.find{|exp| exp.name == ::Model.tactic_response_action.name}}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end
    end
  end

  describe "PUT #update" do
    context "without reuse" do
      let(:old_who) { "Old Who" }
      let(:old_what) { "Old What" }
      let(:old_where) { "Old Where" }
      let(:old_when_date) { Time.now.to_datetime.beginning_of_minute }
      let(:old_when_text) { "" }
      let(:old_response) { "Old Response" }

      before :each do
        @cycle = create :cycle
        @group = create :tactic_group,
          cycle: @cycle,
          father: create(:strategy_group)
        @cycle.groups << @group

        @who_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_who.name}
        @what_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_what.name}
        @where_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_where.name}
        @when_exp = @group.time_expressions.find{
          |exp| exp.name == ::Model.tactic_when.name}
        @response_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_response_action.name}

        @who_exp.update_attribute(:text, old_who)
        @what_exp.update_attribute(:text, old_what)
        @where_exp.update_attribute(:text, old_where)
        @when_exp.update(when: old_when_date, text: old_when_text)
        @response_exp.update_attribute(:text, old_response)

        put :update, {
          tactic: tactic_params,
          cycle_id: @cycle.id,
          incident_id: @cycle.incident.id,
          id: @group.id
        }
      end

      shared_examples :all_expressions_expectations do
        it "have owner that's current user" do
          expect(expression.owner).to be == subject.current_user
        end

        it "have reused equals false" do
          expect(expression).to_not be_reused
        end

        it "have source equals nil" do
          expect(expression.source).to be == nil
        end
      end

      context "updating who" do
        let(:tactic_params){ {who: "New Who"} }
        let(:expression){@who_exp.reload; @who_exp}

        it "update text" do
          expect(expression.text).to be == "New Who"
        end

        include_examples :all_expressions_expectations
      end

      context "updating what" do
        let(:tactic_params){ {what: "New What"} }
        let(:expression){@what_exp.reload; @what_exp}

        it "update text" do
          expect(expression.text).to be == "New What"
        end

        include_examples :all_expressions_expectations
      end

      context "updating where" do
        let(:tactic_params){ {where: "New Where"} }
        let(:expression){@where_exp.reload; @where_exp}

        it "update text" do
          expect(expression.text).to be == "New Where"
        end

        include_examples :all_expressions_expectations
      end

      context "updating when" do
        let(:tactic_params){ {when: "New When"} }
        let(:expression){@when_exp.reload; @when_exp}

        it "update text" do
          expect(expression.text).to be == "New When"
        end

        it "update when" do
          expect(expression.when).to be == nil
        end

        include_examples :all_expressions_expectations
      end

      context "updating response action" do
        let(:tactic_params){ {response_action: "New Response"} }
        let(:expression){@response_exp.reload; @response_exp}

        it "update text" do
          expect(expression.text).to be == "New Response"
        end

        include_examples :all_expressions_expectations
      end

      context "updating when to blank" do
        let(:tactic_params){ {when: ""} }
        let(:expression){@when_exp.reload; @when_exp}

        it "update text to blank" do
          expect(expression.text).to be == ""
        end

        it "update when to nil" do
          expect(expression.when).to be == nil
        end

        include_examples :all_expressions_expectations
      end
    end

    context "with reuse" do
      let(:old_who) { "Old Who" }
      let(:old_what) { "Old What" }
      let(:old_where) { "Old Where" }
      let(:old_when_date) { Time.now.to_datetime.beginning_of_minute }
      let(:old_when_text) { "" }
      let(:old_response) { "Old Response" }

      let(:reused_who){create(:tactic_who)}
      let(:reused_what){create(:tactic_what)}
      let(:reused_where){create(:tactic_where)}
      let(:reused_when){create(:tactic_when)}
      let(:reused_response){create(:tactic_response_action)}

      before :each do
        @cycle = create :cycle
        @group = create :tactic_group,
          cycle: @cycle,
          father: create(:strategy_group)
        @cycle.groups << @group

        @who_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_who.name}
        @what_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_what.name}
        @where_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_where.name}
        @when_exp = @group.time_expressions.find{
          |exp| exp.name == ::Model.tactic_when.name}
        @response_exp = @group.text_expressions.find{
          |exp| exp.name == ::Model.tactic_response_action.name}

        @who_exp.update_attribute(:text, old_who)
        @what_exp.update_attribute(:text, old_what)
        @where_exp.update_attribute(:text, old_where)
        @when_exp.update(when: old_when_date, text: old_when_text)
        @response_exp.update_attribute(:text, old_response)

        put :update, {
          cycle_id: @cycle.id,
          incident_id: @cycle.incident.id,
          id: @group.id,
          tactic: {
            who_reused: reused_who.id,
            what_reused: reused_what.id,
            where_reused: reused_where.id,
            when_reused: reused_when.id,
            response_action_reused: reused_response.id,
          }
        }
      end

      shared_examples :all_expressions_expectations do
        it "is not nil" do
          expect(expression).not_to be nil
        end

        it "have owner that's current user" do
          expect(expression.owner).to be == subject.current_user
        end

        it "have reused equals true" do
          expect(expression).to be_reused
        end

        it "have source equals of reused expression" do
          expect(expression.source).to be == reused_expression.source
        end
      end

      shared_examples :text_expressions_expectations do
        it "have text equals of reused expression" do
          expect(expression.text).to be == reused_expression.text
        end
      end

      describe "the when updated" do
        let(:reused_expression) {reused_when}
        let(:expression) {@when_exp.reload; @when_exp}

        include_examples :all_expressions_expectations

        it "have when equals of reused expression" do
          expect(expression.when).to be == reused_expression.when
        end

        it "have text equals of reused expression" do
          expect(expression.text).to be == reused_expression.text
        end
      end

      describe "the who updated" do
        let(:reused_expression) {reused_who}
        let(:expression) {@who_exp.reload; @who_exp}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the what updated" do
        let(:reused_expression) {reused_what}
        let(:expression) {@what_exp.reload; @what_exp}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the where updated" do
        let(:reused_expression) {reused_where}
        let(:expression) {@where_exp.reload; @where_exp}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end

      describe "the response_action updated" do
        let(:reused_expression) {reused_response}
        let(:expression) {@response_exp.reload; @response_exp}

        include_examples :all_expressions_expectations
        include_examples :text_expressions_expectations
      end
    end

  end
end
