require_relative "accessors"
require_relative "instance_counter"
require_relative "wagon"

class CargoWagon < Wagon
  include Accessors
  include InstanceCounter

  attr_accessor_with_history :occupied_volume
  attr_reader :total_volume

  validate :total_volume, :presence
  validate :total_volume, :type, Integer

  def initialize(number, volume)
    super(number)
    @total_volume = volume
    self.occupied_volume = 0
    validate!
    raise "Total volume should be greater then zero" if @total_volume.zero?
    register_instance
  end

  def free_volume
    total_volume - occupied_volume
  end

  def take_volume(volume)
    raise "Added volume should be greater then zero" if volume.zero?
    raise "There is not enough free volume for this wagon" if occupied_volume + volume >= total_volume
    self.occupied_volume += volume
  end

  def to_s
    "№#{number}, #{type}, free volume: #{free_volume}, occupied volume: #{occupied_volume}"
  end

  def type
    :cargo
  end
end
