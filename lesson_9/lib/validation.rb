module Validation
  module ClassMethods
    attr_accessor :validations

    def validate(attr, type, option = nil)
      @validations ||= {}
      @validations[attr] ||= {}
      @validations[attr][type] = option
    end

    def inherited(subclass)
      super_validations = validations
      subclass.instance_eval do
        self.validations = super_validations
      end
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

    def validate_format(attr, format)
      val = send(attr)
      raise "#{self.class} #{attr} has incorrect format" if val !~ format
    end

    def validate_presence(attr, _option = nil)
      val = send(attr).to_s.strip
      raise "#{self.class} #{attr} can't be empty" if val.empty?
    end

    def validate_type(attr, klass)
      val = send(attr)
      raise "#{self.class} #{attr} must be of the class #{klass}" unless val.instance_of?(klass)
    end

    def validate!
      self.class.validations.each do |attr, options|
        options.each do |type, option|
          send("validate_#{type}", attr, option)
        end
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
