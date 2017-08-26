require_relative "company"

class Wagon
  include Company

  attr_reader :number, :type

  def initialize(number)
    @number = number
  end

  def to_s
    "№ #{number}"
  end
end
