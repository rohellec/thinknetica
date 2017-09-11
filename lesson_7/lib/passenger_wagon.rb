require_relative "wagon"

class PassengerWagon < Wagon
  attr_reader :number_of_seats, :occupied_seats

  def initialize(number, number_of_seats)
    super(number)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
    raise "Number of seats should be greater then zero" if @number_of_seats.zero?
  end

  def free_seats
    number_of_seats - occupied_seats
  end

  def take_seat
    raise "All seats have already been occupied" if occupied_seats == number_of_seats
    @occupied_seats += 1
  end

  def to_s
    "№#{number}, #{type}, free seats: #{free_seats}, occupied seats: #{occupied_seats}"
  end

  def type
    :passenger
  end
end
