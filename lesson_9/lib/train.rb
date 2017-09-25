require_relative "accessors"
require_relative "company"
require_relative "instance_counter"
require_relative "validation"

class Train
  extend Accessors
  include Company
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[^\W_]{3}-?[^\W_]{2}$/

  attr_reader :number, :wagons
  attr_accessor_with_history :route, :speed

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :speed,  :type, Integer

  @trains = {}

  class << self
    attr_reader :trains

    def find(number)
      trains[number]
    end

    def inherited(subclass)
      subclass.instance_eval do
        def self.trains
          @trains ||= {}
        end
      end

      super
    end
  end

  def initialize(number)
    @number = number
    @wagons = []
    self.speed = 0
    validate!
    register_instance
    Train.trains[number] = self
    self.class.trains[number] = self
  end

  def accelerate_by(speed)
    self.speed += speed if speed > 0
  end

  def assign_route(route)
    self.route = route
    route.base_station.receive_train(self)
    @station_index = 0
  end

  def each_wagon(&block)
    wagons.each(&block)
  end

  def current_station
    route.stations[@station_index] if route
  end

  def format
    "#{number}, #{type}, wagons: #{wagons.count}"
  end

  def hook_wagon(wagon)
    validate_on_hook(wagon)
    wagons << wagon
  end

  def move_back
    raise "#{to_s.capitalize} is already at the base station #{current_station}" if at_base_station?
    current_station.send_train(self)
    @station_index -= 1
    current_station.receive_train(self)
  end

  def move_next
    raise "#{to_s.capitalize} is already at the final station #{current_station}" if at_final_station?
    current_station.send_train(self)
    @station_index += 1
    current_station.receive_train(self)
  end

  def stop
    self.speed = 0
  end

  def to_s
    "#{type} train №#{number}"
  end

  def unhook_wagon(wagon)
    validate_on_hook(wagon)
    wagons.delete(wagon)
  end

  private

  # This methods are only used inside the class as service functions

  def at_base_station?
    @station_index.zero?
  end

  def at_final_station?
    @station_index == route.stations.length - 1
  end

  def correct_type?(object)
    object.type == type
  end

  def next_station
    route.stations[@station_index + 1]
  end

  def previous_station
    route.stations[@station_index - 1] unless at_base_station?
  end

  def stopped?
    speed.zero?
  end

  def validate!
    super
    raise "Speed can't be negative" if speed < 0
  end

  def validate_on_hook(wagon)
    raise "Train must be stopped to hook/unhook wagon" unless stopped?
    raise "Wagon and train must be of the same type" unless correct_type?(wagon)
  end
end
