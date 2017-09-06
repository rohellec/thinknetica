require_relative "train"

class CargoTrain < Train
  def initialize(number)
    super(number)
  end

  def type
    :cargo
  end
end
