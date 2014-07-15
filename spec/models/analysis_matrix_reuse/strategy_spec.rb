require 'spec_helper'

describe AnalysisMatrixReuse::Strategy, "reuse strategy hierarchy" do
  describe "when reusing a strategy with one tactic" do
    before :each do
      @reused_strategy = create :strategy_group
      @reused_tactic = create(:tactic_group)
      @reused_strategy.childs = [@reused_tactic]
      @reused_strategy.save!

      exp = create :strategy_how,
        reused: true,
        cycle: create(:cycle)

      @strategy_reusing = exp.group
      @strategy_reusing.text_expressions = [exp]
      @strategy_reusing.save!

      @user = create :user
      AnalysisMatrixReuse::Strategy.reuse_tactics!(@strategy_reusing, owner: @user, reused: @reused_strategy)

      exp.reload
      @tactic_reusing = @strategy_reusing.childs.first
    end

    describe "reusing strategy" do
      it "have only one child" do
        expect(@strategy_reusing.childs.size).to be == 1
      end
    end

    describe "the reusing tactic" do
      it "have the same cycle of reusing strategy" do
        expect(@tactic_reusing.cycle).to be == @strategy_reusing.cycle
      end

      it "have the same number of childs of reused tactic" do
        expect(@tactic_reusing.expressions.size).to be == @reused_tactic.expressions.size
      end

      describe "have expressions reusing the expressions of reused tactic" do
        shared_examples :reusing_expression do
          it "have owner equals user received by parameter" do
            expect(reusing_expression.owner).to be == @user
          end

          it "have the same cycle of reusing strategy" do
            expect(reusing_expression.cycle).to be == @strategy_reusing.cycle
          end

          it "have reused true" do
            expect(reusing_expression).to be_reused
          end

          it "have source equals reused expression source" do
            expect(reusing_expression.source).to be == reused_expression.source
          end
        end

        shared_examples :reusing_text_expression do
          it "have text equals reused expression text" do
            expect(reusing_expression.text).to be == reused_expression.text
          end
        end

        shared_examples :reusing_time_expression do
          it "have text equals reused expression text" do
            expect(reusing_expression.text).to be == reused_expression.text
          end

          it "have when equals reused expression when" do
            expect(reusing_expression.when).to be == reused_expression.when
          end
        end

        describe "who" do
          let(:reusing_expression) {
            @tactic_reusing.expressions.find{|exp| exp.name == ::Model.tactic_who.name}}
          let(:reused_expression) {
            @reused_tactic.expressions.find{|exp| exp.name == ::Model.tactic_who.name}}

          include_examples :reusing_expression
          include_examples :reusing_text_expression
        end
      end
    end
  end
end
