require_relative "train"

class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def hook_wagon
    wagons << PassengerWagon.new if stopped?
  end
end
