module AnalysisMatrixReuse
  module ParamsCleaner
    def self.clean(params)
      reused_params = params.find_all{|key, value| value && key.to_s.ends_with?("_reused")}
      reused_params.each do |(key, value)|
        param_name = key.to_s.gsub(/_reused$/, "").to_sym
        params.delete(param_name)
      end
      params
    end
  end
end
