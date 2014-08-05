module Forms
  class Form202
    include ActiveModel::Model

    attr_accessor :from, :to, :number, :priorities, :incident, :objectives, :objectives_as_str, :cycle, :owner
    validates :objectives,
      presence: true,
      any_blank_element: {
        method: :text
      },
      any_duplication: {
        method: :text,
        message: "can't be duplicated"
      }

    validates :priorities,
      presence: true

    def self.model_name
      ActiveModel::Name.new(::Cycle)
    end

    def self.new_from(cycle)
      form = self.new
      form.cycle = cycle
      form.from = cycle.from
      form.to = cycle.to
      form.number = cycle.number
      form.priorities = cycle.priorities
      form.incident = cycle.incident
      form.objectives = cycle.text_expressions.objectives.load
      form
    end

    def self.normalize(cycle_params)
      flatter = StandardLib::HashFlatter.new(cycle_params)
      flatter.flatten("from"){|values| DateTime.new(*values.map(&:to_i))}
      flatter.flatten("to"){|values| DateTime.new(*values.map(&:to_i))}
      flatter.hash
    end

    def initialize(*args)
      super
      @cycle = Cycle.new
      @objectives ||= []
    end

    def update_with(params)
      params.each do |key, value|
        if value
          if key.to_sym == :objectives_texts
            update_objectives_texts(value)
          else
            self.public_send(:"#{key}=", value)
          end
        end
      end
    end

    def update_objectives_texts(objectives)
      return if objectives.nil?
      texts_to_create = []
      @objectives = []
      objectives.each do |id, text|
        if id == "0"
          texts_to_create = text
        else
          obj = TextExpression.find_by_id(id)
          if obj.nil?
            obj = TextExpression.new_objective(text: text)
          else
            obj.text = text
          end
          @objectives << obj
        end
      end

      texts_to_create.each do |text|
        @objectives << TextExpression.new_objective(text: text)
      end
    end

    def cycle
      @cycle.from = self.from
      @cycle.to = self.to
      @cycle.number = self.number
      @cycle.incident = self.incident
      @cycle.current_object = "to change"
      @cycle.priorities = self.priorities
      @cycle
    end

    def objectives_texts=(objectives_texts)
      return if objectives_texts.nil?
      @objectives = objectives_texts.map do |text|
        TextExpression.new_objective(text: text)
      end
    end

    def objectives_texts
      @objectives.map(&:text)
    end

    def persisted?
      @cycle.persisted?
    end

    def to_param
      @cycle.to_param
    end

    def save
      begin
        ActiveRecord::Base.transaction do
          raise ActiveRecord::RecordInvalid.new(self) unless valid?
          cycle.save!
          return if objectives.nil?

          db_objectives = TextExpression.objectives_of_cycle(cycle.id)
          db_objectives, objs_to_destroy = db_objectives.partition{
            |db_obj| objectives.find{|obj| obj.id == db_obj.id}}
          Expressions::Objective.destroy(objs_to_destroy)

          objectives.each do |objective|
            existent_objective = db_objectives.find{|db_obj| db_obj.id == objective.id}
            if existent_objective.nil? || existent_objective.text != objective.text
              objective.cycle = cycle
              objective.owner = owner
              Expressions::Objective.save!(objective)
            end
          end
        end
      rescue ActiveRecord::ActiveRecordError
        return false
      end
      return true
    end
  end
end
