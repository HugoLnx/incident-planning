module HighModels
  module Model
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model

      attr_accessor :father_id, :cycle_id
      attr_reader :owner

      def self.group_name(name)
        @group_name = name
      end

      def self.text_expression(name, options={})
        expression_name = options[:name]

        @expressions_names ||= {}
        @expressions_names.merge!(name => expression_name)

        define_method :"#{name}_text" do
          exp = instance_variable_get("@#{name}")
          exp && exp.text
        end

        define_method :"update_#{name}" do |new_text|
          exp = instance_variable_get("@#{name}")
          if exp
            if exp.text != new_text
              exp.reused = false
              exp.source = nil
              exp.owner = self.owner
            end
            exp.text = new_text
          end
        end

        define_method :"update_#{name}_reused" do |exp_reused|
          return false if exp_reused.nil?
          exp = instance_variable_get("@#{name}")

          old_reused = exp.reused
          old_text = exp.text
          old_source = exp.source

          exp.reused = true
          exp.text = exp_reused.text
          if exp_reused.source.nil?
            exp.source = exp_reused.owner.email
          else
            exp.source = exp_reused.source
          end

          updated = exp.reused != old_reused ||
              exp.text != old_text ||
              exp.source != old_source

          if updated
            exp.owner = self.owner
          end

          return updated
        end

        define_method :"set_#{name}_reference" do |new_reference|
          instance_variable_set("@#{name}", new_reference)
        end

        define_method :"#{name}_reused=" do |reused_expression|
          return if reused_expression.nil?

          if reused_expression.source.nil?
            source = reused_expression.owner.email
          else
            source = reused_expression.source
          end

          expression = ::TextExpression.new(
            name: expression_name,
            text: reused_expression.text,
            source: source,
            reused: true,
            owner: self.owner
          )
          instance_variable_set("@#{name}", expression)
        end

        define_method :"#{name}=" do |text|
          if text
            expression = ::TextExpression.new(name: expression_name, text: text, owner: self.owner)
            instance_variable_set("@#{name}", expression)
          else
            instance_variable_set("@#{name}", nil)
          end
        end

        define_method name do
          expression = instance_variable_get("@#{name}")
          if expression && !expression.destroyed?
            expression.cycle_id = cycle_id
          end
          expression
        end
      end

      def self.time_expression(name, options={})
        expression_name = options[:name]

        @expressions_names ||= {}
        @expressions_names.merge!(name => expression_name)

        define_method :"update_#{name}" do |new_time_str|
          error_raised = false
          begin
            new_time = DateTime.strptime(new_time_str, TimeExpression::TIME_PARSING_FORMAT)
          rescue ArgumentError 
            error_raised = true
          end

          exp = instance_variable_get("@#{name}") || ::TimeExpression.new(name: expression_name)
          old_when = exp.when
          old_text = exp.text
          if new_time.nil?
            exp.when = nil
            exp.text = new_time_str || ""
          else
            exp.when = new_time
            exp.text = ""
          end

          updated = (old_when != exp.when || old_text != exp.text)
          if updated
            exp.owner = self.owner
            exp.reused = false
            exp.source = nil
          end

          self.instance_variable_set("@#{name}", exp)
          updated
        end

        define_method :"update_#{name}_reused" do |exp_reused|
          return false if exp_reused.nil?
          exp = instance_variable_get("@#{name}")

          old_reused = exp.reused
          old_source = exp.source
          old_text = exp.text
          old_when = exp.when

          exp.reused = true
          if exp_reused.source.nil?
            exp.source = exp_reused.owner.email
          else
            exp.source = exp_reused.source
          end
          exp.text = exp_reused.text
          exp.when = exp_reused.when

          updated = exp.reused != old_reused ||
                    exp.when   != old_when   ||
                    exp.source != old_source ||
                    exp.text   != old_text
                    

          if updated
            exp.owner = self.owner
          end

          return updated
        end

        define_method :"set_#{name}_reference" do |new_reference|
          instance_variable_set("@#{name}", new_reference)
        end

        define_method :"#{name}=" do |time_str|
          begin
            date = time_str && DateTime.strptime(time_str, TimeExpression::TIME_PARSING_FORMAT)
          rescue ArgumentError 
          end
          expression = ::TimeExpression.new(name: expression_name, owner: self.owner)
          if date
            expression.when = date
            expression.text = nil
          else
            expression.when = nil
            expression.text = time_str || ""
          end
          instance_variable_set("@#{name}", expression)
        end

        define_method :"#{name}_reused=" do |reused_expression|
          return if reused_expression.nil?

          if reused_expression.source.nil?
            source = reused_expression.owner.email
          else
            source = reused_expression.source
          end

          expression = ::TimeExpression.new(
            name: expression_name,
            text: reused_expression.text,
            when:  reused_expression.when,
            source: source,
            reused: true,
            owner: self.owner
          )
          instance_variable_set("@#{name}", expression)
        end

        define_method name do
          expression = instance_variable_get("@#{name}")
          if expression && !expression.destroyed?
            expression.cycle_id = cycle_id
          end
          expression
        end
      end
    end

    def initialize(*args)
      @group = ::Group.new
      @group.name = group_name
      super
    end

    def update(attributes = {})
      attributes.each_pair do |attr, value|
        public_send(:"update_#{attr}", value)
      end
    end

    def owner=(user)
      @owner = user
      expressions_names.each do |exp_id, _|
        exp = public_send exp_id
        exp && exp.owner.nil? && exp.owner = @owner
      end
    end

    def group
      if !@group.destroyed?
        @group.father_id = father_id
        @group.cycle_id = cycle_id
      end
      @group
    end

    def my_errors
      my_errors = super
      group.errors.each{|name, msg| my_errors.add(name, msg)}
      expressions_names.each do |exp_id, _|
        exp = public_send exp_id
        exp && exp.errors.each{|name, msg| my_errors.add(name, msg)}
      end
      my_errors
    end

    def save!
      raise ActiveRecord::RecordInvalid.new(self) unless valid?
      rollback_on_error do
        group.save!
        expressions_names.each do |exp_id, _|
          exp = public_send exp_id
          if exp
            exp.group = group
            exp.save!
          end
        end
      end
    end

    def save
      begin
        self.save!
        return true
      rescue ActiveRecord::ActiveRecordError
        return false
      end
    end

    def destroy!
      rollback_on_error do
        @group.destroy!
      end
    end

    def destroy
      begin
        self.destroy!
        return true
      rescue ActiveRecord::ActiveRecordError
        return false
      end
    end

    def set_from_group(group)
      @group = group
      @group.expressions.each do |exp|
        exp_id = find_id_by_expression_name(exp.name)
        exp_id && instance_variable_set("@#{exp_id}", exp)
      end
      @cycle_id = group.cycle_id
      @father_id = group.father_id
    end

  private
    def rollback_on_error(&block)
      ActiveRecord::Base.transaction(requires_new: true) do
        restore_models_if_raise(ActiveRecord::ActiveRecordError, &block)
      end
    end

    def restore_models_if_raise(exception_klass, &block)
      group_clone = @group.clone
      exp_clones = {}
      expressions_names.each do |exp_id, _|
        exp = public_send exp_id
        exp_clones.merge!({exp_id => exp && exp.clone})
      end

      begin
        yield
      rescue exception_klass => e
        @group = group_clone
        exp_clones.each do |exp_id, clone|
          instance_variable_set(:"@#{exp_id}", clone)
        end
        raise e
      end
    end

    def group_name
      self.class.instance_variable_get(:@group_name)
    end

    def expressions_names
      self.class.instance_variable_get(:@expressions_names)
    end

    def find_id_by_expression_name(name_seek)
      expressions_names.each_pair do |exp_id, exp_name|
        if name_seek == exp_name
          return exp_id
        end
      end

      nil
    end
  end
end
