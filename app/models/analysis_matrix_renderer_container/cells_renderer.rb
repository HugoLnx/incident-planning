module AnalysisMatrixRendererContainer
  class CellsRenderer
    attr_reader :cells

    def initialize(cells, callbacks)
      @cells = cells
      @callbacks = callbacks
    end

    def render
      @callbacks.call(@cells.callback_name, *@cells.callback_args)
    end

    def can_be_rendered?
      @callbacks.has_callback?(@cells.callback_name)
    end
  end
end
