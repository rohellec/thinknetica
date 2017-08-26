module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send :instances=, 0
  end

  module ClassMethods
    attr_accessor :instances
    private :instances=
  end

  module InstanceMethods
    private

    def register_instance
      self.class.instances += 1
    end
  end
end
