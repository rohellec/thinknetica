class Wagon
  attr_reader :number, :type

  def initialize(number)
    @number = number
  end

  def to_s
    "№ #{number}"
  end
end
