module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    AnalysisMatrixRendererContainer::RowsIterator.new(matrix_data).each_row(&block)
  end
end
