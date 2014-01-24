module Forms
  class Form234
    include ActiveModel::Model

    attr_accessor :incident
    attr_accessor :cycle
    attr_accessor :name

    def self.model_name
      ActiveModel::Name.new(nil, nil, "AnalysisMatrix")
    end
  end
end
