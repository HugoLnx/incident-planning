module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    RowsIterator.new(matrix_data).each_row(&block)
  end
end
