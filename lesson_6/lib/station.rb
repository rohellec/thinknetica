class Station
  attr_reader :name

  @@stations = []

  class << self
    def all
      @@stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def to_s
    name
  end

  def trains(type = nil)
    return @trains if type.nil?
    @trains.find_all { |train| train.type == type }
  end

  private

  def validate!
    raise "Station name can't be empty" if name.empty?
    true
  end

  def valid?
    validate!
  rescue
    false
  end
end
