module AnalysisMatrixRendererContainer
  class Callbacks
    def initialize(callbacks={})
      @callbacks = callbacks
    end

    def call(name, *args)
      @callbacks[name] && @callbacks[name].call(*args)
    end

    def has_callback?(name)
      @callbacks.has_key? name
    end
  end
end
