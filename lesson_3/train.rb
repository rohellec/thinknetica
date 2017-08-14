class Train
  attr_reader :wagon_count, :speed

  def initialize(number, type, wagon_count)
    @number = number
    @speed = 0
    @type = type
    @wagon_count = wagon_count
  end

  def accelerate_by(speed)
    @speed += speed
  end

  def assign_route(route)
    @route = route
    @route.stations.first.receive(self)
    @station = 0
  end

  def current_station
    @route[@station] if @route
  end

  def hook_wagon
    @wagon_count += 1
  end

  def move_back
    return unless previous_station?
    current_station.send(self)
    previous_station.receive(self)
    @station -= 1
  end

  def move_next
    return unless next_station?
    current_station.send(self)
    next_station.receive(self)
    @station += 1
  end

  def next_station
    @route[@station + 1] if next_station?
  end

  def previous_station
    @route[@station - 1] if previous_station?
  end

  def stop
    @speed = 0
  end

  def unhook_wagon
    @wagon_count -= 1 if @wagon_count > 0
  end

  private

  def next_station?
    @station < @route.stations.length
  end

  def previous_station?
    @station > 0
  end
end
