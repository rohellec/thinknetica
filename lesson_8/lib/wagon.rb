require_relative "company"

class Wagon
  include Company

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
  end

  protected

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    raise "Wagon number can't be zero" if number.zero?
  end
end
