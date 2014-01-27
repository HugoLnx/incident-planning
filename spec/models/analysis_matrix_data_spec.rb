require "spec_helper"

describe AnalysisMatrixData do
  context "when exist a unique objective" do
    context "without strategies" do
      before :each do
        @objective = build :objective_group
        matrix = build :analysis_matrix_data,
          objectives: [@objective]
        @rows = matrix.rows
      end

      it "have one row" do
        expect(@rows.size).to be == 1
      end

      it "the row have only the objective" do
        expect(@rows.first.objective.group).to be == @objective
        expect(@rows.first.strategy).to be_nil
        expect(@rows.first.tactic).to be_nil
      end

      it "the objective is non-repeated" do
        expect(@rows.first.objective_repeated).to be_false
      end
    end

    context "with two strategies that have no tactics" do
      before :each do
        @objective = build(:objective_group,
          childs: build_list(:strategy_group, 2)
        )
        @strategies = @objective.childs

        matrix = build :analysis_matrix_data,
          objectives: [@objective]

        @rows = matrix.rows
      end

      it "have two rows" do
        expect(@rows.size).to be == 2
      end

      it "no rows have tactic" do
        expect(@rows[0].tactic).to be_nil
        expect(@rows[1].tactic).to be_nil
      end

      it "the groups in the rows are the ones in hierarchy" do
        expect(@rows[0].objective.group).to be == @objective
        expect(@rows[0].strategy.group).to be == @strategies[0]
        expect(@rows[1].strategy.group).to be == @strategies[1]
      end

      it "the objective repeat in the second row" do
        expect(@rows[1].objective).to be == @rows[0].objective
      end

      it "objective of the second row is marked as repeated" do
        expect(@rows[1].objective_repeated).to be_true
      end

      it "all strategies is marked as non-repeated" do
        expect(@rows[0].strategy_repeated).to be_false
        expect(@rows[1].strategy_repeated).to be_false
      end
    end

    context "with one strategy that have two tactics" do
      before :each do
        @objective = build(:objective_group, childs:[
          build(:strategy_group, 
            childs: build_list(:tactic_group, 2)
          )
        ])

        @strategy = @objective.childs.first
        @tactics = @strategy.childs

        matrix = build :analysis_matrix_data,
          objectives: [@objective]

        @rows = matrix.rows
      end

      it "have two rows" do
        expect(@rows.size).to be == 2
      end

      it "strategy and objective of second row are marked as repeated" do
        expect(@rows[1].objective_repeated).to be_true
        expect(@rows[1].strategy_repeated).to be_true
      end

      it "all the others groups are marked as non-repeated" do
        expect(@rows[0].objective_repeated).to be_false
        expect(@rows[0].strategy_repeated).to be_false
        expect(@rows[0].tactic_repeated).to be_false
        expect(@rows[1].tactic_repeated).to be_false
      end

      it "the groups in the rows are the ones in hierarchy" do
        expect(@rows[0].objective.group).to be == @objective
        expect(@rows[0].strategy.group).to be == @strategy
        expect(@rows[0].tactic.group).to be == @tactics[0]

        expect(@rows[1].objective.group).to be == @rows[0].objective.group
        expect(@rows[1].strategy.group).to be == @rows[0].strategy.group
        expect(@rows[1].tactic.group).to be == @tactics[1]
      end
    end
  end
end
