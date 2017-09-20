module Validation
  module ClassMethods
    VALIDATIONS = {
      presence: :validate_presence_of,
      format:   :validate_format_of,
      type:     :validate_type_of
    }

    attr_reader :validations

    def validate(attr, type, *args)
      action = VALIDATIONS.fetch(type)
      send(action, attr, *args)
      @validations ||= []
      @validations |= ["#{action}_#{attr}"]
    end

    private

    def validate_presence_of(arg)
      define_method("validate_presence_of_#{arg}") do
        attr = send(arg)
        empty = attr.respond_to?(:empty?) && attr.empty?
        raise "#{self.class} #{arg} can't be empty" if attr.nil? || empty
      end

      private "validate_presence_of_#{arg}"
    end

    def validate_format_of(arg, format)
      define_method("validate_format_of_#{arg}") do
        attr = send(arg)
        raise "#{self.class} #{arg} has incorrect format" if attr !~ format
      end

      private "validate_format_of_#{arg}"
    end

    def validate_type_of(arg, klass)
      define_method("validate_type_of_#{arg}") do
        attr = send(arg)
        raise "#{self.class} #{arg} must be of the class #{klass}" unless attr.instance_of?(klass)
      end

      private "validate_type_of_#{arg}"
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate!
      self.class.validations.each { |validation| send(validation) }
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
