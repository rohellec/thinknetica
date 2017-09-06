require_relative "wagon"

class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume

  def initialize(number, volume)
    super(number)
    @total_volume = volume
    @occupied_volume = 0
    raise "Total volume should be greater then zero" if @total_volume.zero?
  end

  def free_volume
    total_volume - occupied_volume
  end

  def take_volume(volume)
    raise "Added volume should be greater then zero" if volume.zero?
    raise "There is not enough free volume for this wagon" if total_volume == occupied_volume
    @total_volume += volume
  end

  def to_s
    "№#{number}, cargo, free volume: #{free_volume}, occupied volume: #{occupied_volume}"
  end

  def type
    :cargo
  end
end
