require_relative "train"

class PassengerTrain < Train
  def initialize(number)
    super(number)
  end

  def type
    :passenger
  end
end