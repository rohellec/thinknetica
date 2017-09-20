module Accessors
  module ClassMethods
    def attr_accessor_with_history(*attrs)
      attrs.each do |attr|
        define_method("#{attr}") { instance_variable_get(:"@#{attr}") }

        define_method("#{attr}_history") do
          history = instance_variable_get(:"@#{attr}_history")
          history || instance_variable_set(:"@#{attr}_history", [])
        end

        define_method("#{attr}=") do |arg|
          instance_variable_set(:"@#{attr}", arg)
          send("#{attr}_history").push(arg)
        end
      end
    end

    def strong_attr_accessor(attr, klass)
      define_method("#{attr}") { instance_variable_get(:"@#{attr}") }

      define_method("#{attr}=") do |arg|
        raise "Argument #{arg} should be of the class #{klass}" unless arg.instance_of?(klass)
        instance_variable_set(:"@#{attr}", arg)
      end
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
