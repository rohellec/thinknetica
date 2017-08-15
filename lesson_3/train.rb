class Train
  attr_reader :wagon_count, :speed

  def initialize(number, type, wagon_count)
    @number = number
    @speed = 0
    @type = type
    @wagon_count = wagon_count
  end

  def accelerate_by(speed)
    @speed += speed if speed > 0
  end

  def assign_route(route)
    @route = route
    @route.base_station.receive_train(self)
    @station_index = 0
  end

  def current_station
    @route.stations[@station_index] if @route
  end

  def hook_wagon
    @wagon_count += 1 if stopped?
  end

  def move_back
    return unless previous_station?
    current_station.send_train(self)
    @station_index -= 1
    current_station.receive_train(self)
  end

  def move_next
    return unless next_station?
    current_station.send_train(self)
    @station_index += 1
    current_station.receive_train(self)
  end

  def next_station
    @route.stations[@station_index + 1]
  end

  def previous_station
    @route.stations[@station_index - 1] if previous_station?
  end

  def stop
    @speed = 0
  end

  def unhook_wagon
    @wagon_count -= 1 if stopped? && @wagon_count > 0
  end

  private

  def stopped?
    speed.zero?
  end

  def next_station?
    @station_index < @route.stations.length
  end

  def previous_station?
    @station_index > 0
  end
end
