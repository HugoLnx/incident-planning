require 'spec_helper'

module AnalysisMatrixRendererContainer
  describe RowsIterator, %q{
    Iterate over each row, calling callbacks in customized event ocurrences
  } do
    let(:callback_show_objective) {double :show_objective}
    let(:callback_show_strategy) {double :show_strategy}
    let(:callback_show_tactic) {double :show_tactic}
    let(:callback_new_strategy) {double :new_strategy}
    let(:callback_new_tactic) {double :new_tactic}

    subject do
      RowsIterator.new(data, callbacks: {
        show_objective: callback_show_objective,
        show_strategy: callback_show_strategy,
        show_tactic: callback_show_tactic,
        new_strategy: callback_new_strategy,
        new_tactic: callback_new_tactic
      })
    end

    context "when data have only one objective" do
      let(:objective) {build :objective_group, id: 9}
      let :data do
        build :analysis_matrix_data,
          objectives: [objective]
      end

      context "when rendering objective cells" do
        it "call show_objective callback once" do
          expect(callback_show_objective).to receive(:call).once do |objective, repeated|
            expect(objective).to be_kind_of Groups::Objective
            expect(repeated).to be_false
          end
          subject.each_row{|row| row.objective_cells.render}
        end
      end

      context "when rendering strategy cells" do
        it "call new_strategy callback once" do
          expect(callback_new_strategy).to receive(:call).once.with(objective.id)
          subject.each_row{|row| row.strategy_cells.render}
        end
      end

      context "when rendering tactic cells" do
        it "call show_tactic callback once" do
          expect(callback_show_tactic).to receive(:call).once do |tactic, repeated|
            expect(tactic).to be_nil
            expect(repeated).to be_false
          end
          subject.each_row{|row| row.tactic_cells.render}
        end
      end
    end

    context "when data have an objective with strategy" do
      let :objective do
        build(:objective_group, id: 9,
          childs: [build(:strategy_group)])
      end

      let :data do
        build :analysis_matrix_data,
          objectives: [objective]
      end

      context "when rendering objective cells" do
        it "call show_objective callback twice" do
          expect(callback_show_objective).to receive(:call).ordered do |objective, repeated|
            expect(objective).to be_kind_of Groups::Objective
            expect(repeated).to be_false
          end

          expect(callback_show_objective).to receive(:call).ordered do |objective, repeated|
            expect(objective).to be_kind_of Groups::Objective
            expect(repeated).to be_true
          end
          subject.each_row{|row| row.objective_cells.render}
        end
      end

      context "when rendering strategy cells" do
        it "call show_strategy followed by new_strategy callbacks" do
          expect(callback_show_strategy).to receive(:call).ordered do |strategy, repeated|
            expect(strategy).to be_kind_of Groups::Strategy
            expect(repeated).to be_false
          end
          expect(callback_new_strategy).to receive(:call).ordered.with(objective.id)
          subject.each_row{|row| row.strategy_cells.render}
        end
      end

      context "when rendering tactic cells" do
        it "call new_tactic followed by show_tactic callbacks" do
          expect(callback_new_tactic).to receive(:call).ordered

          expect(callback_show_tactic).to receive(:call).ordered do |tactic, repeated|
            expect(tactic).to be_nil
            expect(repeated).to be_false
          end
          subject.each_row{|row| row.tactic_cells.render}
        end
      end
    end

    context "when data have an objective with strategy with tactic" do
      let :objective do
        build(:objective_group, id: 9,
          childs: [build(:strategy_group,
            childs: [build(:tactic_group)])
          ]
        )
      end

      let :data do
        build :analysis_matrix_data,
          objectives: [objective]
      end

      context "when rendering objective cells" do
        it "call show_objective callback three times" do
          expect(callback_show_objective).to receive(:call).ordered do |objective, repeated|
            expect(objective).to be_kind_of Groups::Objective
            expect(repeated).to be_false
          end

          expect(callback_show_objective).to receive(:call).twice.ordered do |objective, repeated|
            expect(objective).to be_kind_of Groups::Objective
            expect(repeated).to be_true
          end
          subject.each_row{|row| row.objective_cells.render}
        end
      end

      context "when rendering strategy cells" do
        it "call show_strategy twice followed by new_strategy callbacks" do
          expect(callback_show_strategy).to receive(:call).ordered do |strategy, repeated|
            expect(strategy).to be_kind_of Groups::Strategy
            expect(repeated).to be_false
          end
          expect(callback_show_strategy).to receive(:call).ordered do |strategy, repeated|
            expect(strategy).to be_kind_of Groups::Strategy
            expect(repeated).to be_true
          end
          expect(callback_new_strategy).to receive(:call).ordered.with(objective.id)
          subject.each_row{|row| row.strategy_cells.render}
        end
      end

      context "when rendering tactic cells" do
        it "call show_tactic => new_tactic => show_tactic callbacks" do
          expect(callback_show_tactic).to receive(:call).ordered do |tactic, repeated|
            expect(tactic).to be_kind_of Groups::Tactic
            expect(repeated).to be_false
          end

          expect(callback_new_tactic).to receive(:call).ordered

          expect(callback_show_tactic).to receive(:call).ordered do |tactic, repeated|
            expect(tactic).to be_nil
            expect(repeated).to be_false
          end

          subject.each_row{|row| row.tactic_cells.render}
        end
      end
    end
  end
end
