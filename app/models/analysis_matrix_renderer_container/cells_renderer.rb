module AnalysisMatrixRendererContainer
  class CellsRenderer
    def initialize(cells, callbacks)
      @cells = cells
      @callbacks = callbacks
    end

    def render
      @cells.render_using(@callbacks)
    end
  end
end
