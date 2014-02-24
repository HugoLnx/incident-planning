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

        @expressions_names ||= []
        @expressions_names << name

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
          expression && expression.cycle_id = cycle_id
          expression
        end
      end
    end

    def update(attributes = {})
      attributes.each_pair do |attr, value|
        public_send(:"update_#{attr}", value)
      end
    end

    def group_name
      self.class.instance_variable_get(:@group_name)
    end

    def expressions_names
      self.class.instance_variable_get(:@expressions_names)
    end

    def initialize(*args)
      @group = ::Group.new
      @group.name = group_name
      super
    end

    def group
      @group.father_id = father_id
      @group.cycle_id = cycle_id
      @group
    end

    def errors
      my_errors = super
      group.errors.each{|name, msg| my_errors.add(name, msg)}
      expressions_names.each do |exp_name|
        exp = public_send exp_name
        exp && exp.errors.each{|name, msg| my_errors.add(name, msg)}
      end
      my_errors
    end

    def save
      begin
        return false unless valid?
        ActiveRecord::Base.transaction do
          group.save!
          expressions_names.each do |exp_name|
            exp = public_send exp_name
            if exp
              exp.group = group
              exp.save!
            end
          end
        end
        return true
      rescue ActiveRecord::ActiveRecordError
        return false
      end
    end

    def set_from_group(group)
      @group = group
      @group.text_expressions.each do |exp|
        instance_variable_set("@#{exp.name}", exp)
      end
      @cycle_id = group.cycle_id
      @father_id = group.father_id
    end

    module ClassMethods
    end
  end
end
