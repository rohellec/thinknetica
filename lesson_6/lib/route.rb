class Route
  attr_reader :stations

  def initialize(base_station, final_station)
    @stations = [base_station, final_station]
    validate
  end

  def add(station)
    raise "Station #{station} has already been added to the route" if stations.include?(station)
    stations.insert(-2, station)
  end

  def base_station
    stations.first
  end

  def delete(station)
    if station == base_station && station == final_station
      raise "Neither base nor final station can't be deleted from the route"
    end
    stations.delete(station)
  end

  def final_station
    stations.last
  end

  def to_s
    "from #{base_station} to #{final_station}"
  end

  private

  def validate!
    if base_station.nil? || final_station.nil?
      raise "Base and final stations must be mentioned for the route"
    end
    if base_station == final_station
      raise "Base and final stations must be different"
    end
    true
  end

  def valid?
    validate!
  rescue
    false
  end
end
