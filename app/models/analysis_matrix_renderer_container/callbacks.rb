module AnalysisMatrixRendererContainer
  class Callbacks
    def initialize(callbacks={})
      @callbacks = callbacks
    end

    def call(name, *args)
      @callbacks[name] && @callbacks[name].call(*args)
    end
  end
end
