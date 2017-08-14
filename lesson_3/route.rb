class Route
  attr_reader :stations

  def initialize(base_station, final_station)
    @stations = [base_station, final_station]
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def delete(station)
    @stations.delete(station)
  end
end
