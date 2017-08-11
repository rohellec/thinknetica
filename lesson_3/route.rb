class Route
  def initialize(base_station, final_station)
    @base_station  = base_station
    @final_station = final_station
    @stations = []
  end

  def add(station)
    @stations << station
  end

  def delete(station)
    @stations.delete(station)
  end

  def stations
    route = Array.new(@stations).push(@final_station).unshift(@base_station)
    puts route
  end
end