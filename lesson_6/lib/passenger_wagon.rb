require_relative "wagon"

class PassengerWagon < Wagon
  def initialize(number)
    super(number, :passenger)
  end
end
