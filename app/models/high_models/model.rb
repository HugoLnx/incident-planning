module HighModels
  module Model
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model

      attr_accessor :father_id, :cycle_id

      def self.group_name(name)
        @group_name = name
      end

      def self.text_expression(name, options={})
        expression_name = options[:name]

        @expressions_names ||= {}
        @expressions_names.merge!(name => expression_name)

        define_method :"update_#{name}" do |new_text|
          exp = instance_variable_get("@#{name}")
          if exp
            exp.text = new_text
          end
        end

        define_method :"set_#{name}_reference" do |new_reference|
          instance_variable_set("@#{name}", new_reference)
        end

        define_method :"#{name}=" do |text|
          if text
            expression = ::TextExpression.new(name: expression_name, text: text)
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
    end

    def update(attributes = {})
      attributes.each_pair do |attr, value|
        public_send(:"update_#{attr}", value)
      end
    end

    def initialize(*args)
      @group = ::Group.new
      @group.name = group_name
      super
    end

    def group
      if !@group.destroyed?
        @group.father_id = father_id
        @group.cycle_id = cycle_id
      end
      @group
    end

    def errors
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
        expressions_names.each do |exp_id, _|
          exp = public_send exp_id
          if exp
            exp.group = group
            exp.destroy!
          end
        end
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
      @group.text_expressions.each do |exp|
        exp_id = find_id_by_expression_name(exp.name)
        instance_variable_set("@#{exp_id}", exp)
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
