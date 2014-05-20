module AnalysisMatrixRendererContainer
  class CellsRenderer
    attr_reader :cells

    def initialize(cells, callbacks)
      @cells = cells
      @callbacks = callbacks
    end

    def render
      @cells.render_using(@callbacks)
    end
  end
end
