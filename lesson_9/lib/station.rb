require_relative "instance_counter"
require_relative "validation"

class Station
  include InstanceCounter
  include Validation

  attr_reader :name

  validate :name, :presence
  validate :name, :type, String

  @stations = []

  class << self
    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    self.class.all << self
  end

  def each_train(type, &block)
    trains(type).each(&block)
  end

  def display_trains(type)
    each_train(type).with_index(1) { |train, index| puts "#{index}. #{train.format}" }
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def to_s
    name
  end

  def trains(type = nil)
    return @trains if type.nil?
    @trains.find_all { |train| train.type == type }
  end
end
