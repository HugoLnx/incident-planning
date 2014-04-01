module PageObjects
  class AnalysisMatrixMetadataDialogPO
    attr_reader :element

    def initialize(user_knowledge, element)
      @user = user_knowledge
      @element = element
    end

    def click_approve
      @element.click_on "Approve"
      AnalysisMatrixPO.new(@user)
    end
  end
end
