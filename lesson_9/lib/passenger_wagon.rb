require_relative "accessors"
require_relative "instance_counter"
require_relative "wagon"

class PassengerWagon < Wagon
  include Accessors
  include InstanceCounter

  attr_accessor_with_history :occupied_seats
  attr_reader :number_of_seats

  validate :number_of_seats, :presence
  validate :number_of_seats, :type, Integer

  def initialize(number, number_of_seats)
    super(number)
    @number_of_seats = number_of_seats
    self.occupied_seats = 0
    validate!
    raise "Number of seats should be greater then zero" if @number_of_seats.zero?
    register_instance
  end

  def free_seats
    number_of_seats - occupied_seats
  end

  def take_seat
    raise "All seats have already been occupied" if occupied_seats == number_of_seats
    self.occupied_seats += 1
  end

  def to_s
    "№#{number}, #{type}, free seats: #{free_seats}, occupied seats: #{occupied_seats}"
  end

  def type
    :passenger
  end
end
