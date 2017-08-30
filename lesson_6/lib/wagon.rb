require_relative "company"

class Wagon
  include Company

  attr_reader :number, :type

  VALID_TYPES = [:cargo, :passenger]

  def initialize(number, type)
    @number = number
    @type = type
    validate!
  end

  def to_s
    "№ #{number}"
  end

  protected

  def valid?
    validate!
  rescue
    false
  end

  private

  def validate!
    raise "Wagon number can't be zero" if number.zero?
    raise "Invalid type" unless VALID_TYPES.include?(type)
    true
  end
end
