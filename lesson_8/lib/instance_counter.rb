module InstanceCounter
  module ClassMethods
    def instances
      @instances ||= 0
    end

    attr_writer :instances
  end

  module InstanceMethods
    private

    def register_instance
      self.class.instances += 1
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
end