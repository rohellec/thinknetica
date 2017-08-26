require_relative "company"

class Train
  include Company

  attr_reader :number, :route, :speed, :type, :wagons

  @@trains = {}

  class << self
    def find(number)
      @@trains[number]
    end
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @@trains[number] = self
  end

  def accelerate_by(speed)
    @speed += speed if speed > 0
  end

  def assign_route(route)
    @route = route
    @route.base_station.receive_train(self)
    @station_index = 0
  end

  def at_base_station?
    @station_index.zero?
  end

  def at_final_station?
    @station_index == route.stations.length - 1
  end

  def current_station
    route.stations[@station_index] if route
  end

  def hook_wagon(wagon)
    return unless stopped?
    wagons << wagon if correct_type?(wagon)
  end

  def move_back
    return if at_base_station?
    current_station.send_train(self)
    @station_index -= 1
    current_station.receive_train(self)
  end

  def move_next
    return if at_final_station?
    current_station.send_train(self)
    @station_index += 1
    current_station.receive_train(self)
  end

  def stop
    @speed = 0
  end

  def to_s
    "#{type} train №#{number}"
  end

  def unhook_wagon(wagon)
    return unless stopped?
    wagons.delete(wagon) if correct_type?(wagon)
  end

  private

  # This methods are only used inside the class as service functions

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
end
