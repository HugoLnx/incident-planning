module HighModels
  class Strategy
    include HighModels::Model

    text_expression :how, name: ::Model.strategy_how.name
    text_expression :why, name: ::Model.strategy_why.name

    group_name ::Model.strategy.name

    validates :father_id, presence: true
    validates :how, presence: true
  end
end
