require_relative "train"

class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def hook_wagon
    wagons << CargoWagon.new if stopped?
  end
end
