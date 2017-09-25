require_relative "company"
require_relative "validation"

class Wagon
  include Company
  include Validation

  attr_reader :number

  validate :number, :presence
  validate :number, :type, Integer

  def initialize(number)
    @number = number
  end
end
