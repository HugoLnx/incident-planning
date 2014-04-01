module PageObjects
  class AnalysisMatrixTacticCellPO
    extend Forwardable

    def initialize(user, element)
      @user = user
      @cell = AnalysisMatrixCellPO.new(user, element)
    end

    def_delegators :@cell, :row_parent, :show_metadata, :element

    def open_edit_mode
      row_element = @cell.row_parent
      @cell.double_click
      form_element = row_element.find ".tactic.who.form"
      AnalysisMatrixTacticFormPO.new(@user, form_element)
    end
  end
end
