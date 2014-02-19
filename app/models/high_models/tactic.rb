module HighModels
  class Tactic
    include HighModels::Model

    text_expression :who, name: ::Model.tactic_who.name
    text_expression :what, name: ::Model.tactic_what.name
    text_expression :where, name: ::Model.tactic_where.name
    text_expression :when, name: ::Model.tactic_when.name
    text_expression :response_action, name: ::Model.tactic_response_action.name

    group_name ::Model.tactic.name

    validates :father_id, presence: true
    validates :who, presence: true
    validates :what, presence: true
    validates :where, presence: true
  end
end
