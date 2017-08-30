require_relative "train"

class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end
end
