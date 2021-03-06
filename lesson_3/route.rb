class Route
  attr_reader :stations

  def initialize(base_station, final_station)
    @stations = [base_station, final_station]
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def base_station
    stations.first
  end

  def delete(station)
    if station != base_station && station != final_station
      @stations.delete(station)
    end
  end

  def final_station
    stations.last
  end
end
