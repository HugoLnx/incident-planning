module PageObjects
  class AnalysisMatrixCellPO
    attr_reader :element

    def initialize(user, element)
      @user = user
      @element = element
    end

    def row_parent
      @element.find(:xpath, "..")
    end

    def double_click
      @element.native.double_click
    end

    def show_metadata
      @element.click
      metadata_dialog = @element.session.all(".ui-dialog .metadata").last
      AnalysisMatrixMetadataDialogPO.new(@user, metadata_dialog)
    end
  end
end
