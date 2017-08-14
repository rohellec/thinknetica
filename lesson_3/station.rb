class Station
  def initialize(name)
    @name = name
    @trains = []
  end

  def receive(train)
    @trains << train
  end

  def send(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    if type
      @trains.find_all { |train| train.type == train }
    else
      @trains
    end
  end
end
