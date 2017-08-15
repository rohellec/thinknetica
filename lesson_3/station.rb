class Station
  def initialize(name)
    @name = name
    @trains = []
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    return @trains if type.nil?
    @trains.find_all { |train| train.type == type }
  end
end
