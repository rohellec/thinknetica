class Console
  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def run
    puts "Welcome to Trainspotting program!"
    main_menu
  end

  private

  attr_reader :stations, :trains, :routes

  def main_menu
    system("clear")
    loop do
      puts "Main menu"
      puts "1. Create station"
      puts "2. Create train"
      puts "3. Route management"
      puts "4. Assign route to train"
      puts "5. Hook wagon to the train"
      puts "6. Unhook wagon from the train"
      puts "7. Move the train along the route"
      puts "8. Display stations and trains on them"
      puts "0. Quit"
      puts "Please, choose the action:"
      print ">"
      input = gets.to_i
      case input
      when 1 then create_station
      when 2 then create_train
      when 3 then route_menu
      when 4 then assign_route
      when 5 then hook_wagon
      when 6 then unhook_wagon
      when 7 then move_train
      when 8 then display_stations
      when 0 then break
      else wrong_input
      end
    end
  end

  def create_station
    system("clear")
    name = ''
    loop do
      puts "Please, enter the name of the station:"
      print ">"
      name = gets.chomp
      break unless name.empty?
      wrong_input
    end
    station = Station.new(name)
    stations << station
    system("clear")
    puts "Station #{station} has been created!"
  end

  def create_train
    system("clear")
    type = choose_train_type_create
    number = 0
    loop do
      puts "Please, enter the number of the train:"
      print ">"
      number = gets.to_i
      break unless number.zero?
      wrong_input
    end
    case type
    when :cargo     then train = CargoTrain.new(number)
    when :passenger then train = PassengerTrain.new(number)
    end
    trains << train
    system("clear")
    puts "#{train} has been created!"
  end

  def choose_train_type_create
    loop do
      puts "What type of train do you want to create?"
      puts "1. Cargo"
      puts "2. Passenger"
      puts "Please, choose the type:"
      print ">"
      input = gets.to_i
      case input
      when 1 then return :cargo
      when 2 then return :passenger
      else wrong_input
      end
    end
  end

  def route_menu
    system("clear")
    loop do
      puts "Route menu"
      puts "1. Create route"
      puts "2. Add stations to route"
      puts "3. Remove stations from route"
      puts "4. Main menu"
      puts "Please, choose the action:"
      print ">"
      input = gets.to_i
      case input
      when 1 then create_route
      when 2 then add_stations_to_route
      when 3 then remove_stations_from_route
      when 4 then system("clear") && return
      else wrong_input
      end
    end
  end

  def create_route
    system("clear")
    check_stations
    base, final = nil, nil
    loop do
      list_stations
      puts "Please, enter the indexes of the base and final stations accordingly:"
      print ">"
      indexes = gets.chomp.split(/\W+/).map(&:to_i)
      base, final = indexes.map { |i| stations[i - 1] }
      break if base && final
      wrong_input
    end
    route = Route.new(base, final)
    routes << route
    system("clear")
    puts "Route #{route} has been created!"
  end

  def check_stations
    return if stations.size >= 2
    while stations.size < 2
      puts "There should be at least 2 stations before you can create the route."
      puts "#{2 - stations.size} more left. Do you want to create the station? (Y/n)"
      print ">"
      input = gets.chomp.downcase
      break unless input.empty? || input =~ "y"
      create_station
    end
  end

  def add_stations_to_route
    system("clear")
    route = choose_route
    input_stations = []
    loop do
      list_stations
      puts "Please, enter the indexes of stations you want to add:"
      print ">"
      indexes = gets.chomp.split(/\W+/).map(&:to_i)
      input_stations = indexes.map { |i| stations[i - 1] }
      break if input_stations.any?
      wrong_input
    end
    input_stations.each { |station| route.add(station) }
    system("clear")
    puts "Stations #{input_stations.join(", ")} have been added to the route #{route}!"
  end

  def remove_stations_from_route
    system("clear")
    route = choose_route
    input_stations = []
    loop do
      list_stations(route.stations)
      puts "Please, enter the indexes of stations you want to remove:"
      print ">"
      indexes = gets.chomp.split(/\W+/).map(&:to_i)
      input_stations = indexes.map { |i| route.stations[i - 1] }
      break if input_stations.any?
      wrong_input
    end
    input_stations.each { |station| route.delete(station) }
    system("clear")
    puts "Stations #{input_stations.join(", ")} have been removed from the route #{route}!"
  end

  def assign_route(train = nil)
    system("clear")
    train = choose_train unless train
    route = choose_route
    train.assign_route(route)
    puts "Route #{route} has been assigned to #{train}!"
  end

  def hook_wagon
    system("clear")
    train = choose_train
    train.hook_wagon
    puts "Wagon has been hooked to the #{train}!"
  end

  def unhook_wagon
    system("clear")
    train = choose_train
    train.unhook_wagon
    puts "Wagon has been unhooked from the #{train}!"
  end

  def move_train
    system("clear")
    train = choose_train
    unless train.route
      puts "Sorry, you need to assign route to this train first!"
      puts "Do you want to assign route? (Y/n)"
      print ">"
      input = gets.chomp.downcase
      return unless input.empty? || input =~ "y"
      assign_route(train)
    end
    move_menu(train)
  end

  def move_menu(train)
    system("clear")
    puts "Train #{train} route menu:"
    loop do
      puts "1. Move train forward"
      puts "2. Move train backward"
      puts "3. Choose another train"
      puts "4. Main menu"
      puts "Please, choose the action:"
      print ">"
      input = gets.to_i
      case input
      when 1 then move_train_forward(train)
      when 2 then move_train_backward(train)
      when 3 then move_train
      when 4 then system("clear") && return
      else wrong_input
      end
    end
  end

  def move_train_forward(train)
    if train.at_final_station?
      puts "#{train.to_s.capitalize} is already at the final station #{train.current_station}!"
    else
      train.move_next
      puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
    end
  end

  def move_train_backward(train)
    if train.at_base_station?
      puts "#{train.to_s.capitalize} is already at the base station #{train.current_station}!"
    else
      train.move_back
      puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
    end
  end

  def display_stations
    system("clear")
    station = choose_station
    type = choose_train_type_display
    system("clear")
    puts "#{type ? type.capitalize : 'All'} trains on station #{station}"
    list_trains(station.trains(type))
  end

  def choose_train_type_display
    loop do
      puts "Trains of which type do you want to see:"
      puts "1. Cargo"
      puts "2. Passenger"
      puts "3. All"
      puts "Please, choose the type:"
      print ">"
      input = gets.to_i
      case input
      when 1 then return :cargo
      when 2 then return :passenger
      when 3 then return nil
      else wrong_input
      end
    end
  end

  def choose_route
    loop do
      list_routes
      puts "Please, choose the route:"
      print ">"
      route = routes[gets.to_i - 1]
      if route
        system("clear")
        return route
      else
        wrong_input
      end
    end
  end

  def choose_station
    loop do
      list_stations
      puts "Please, choose the station:"
      print ">"
      station = stations[gets.to_i - 1]
      if station
        system("clear")
        return station
      else
        wrong_input
      end
    end
  end

  def choose_train
    loop do
      puts "List of trains:"
      list_trains
      puts "Please, choose the train:"
      print ">"
      train = trains[gets.to_i - 1]
      if train
        system("clear")
        return train
      else
        wrong_input
      end
    end
  end

  def list_routes
    puts "List of routes:"
    routes.each_with_index { |route, index| puts "#{index + 1}. Route #{route}" }
  end

  def list_stations(stations = @stations)
    puts "List of stations:"
    stations.each_with_index { |station, index| puts "#{index + 1}. #{station}" }
  end

  def list_trains(trains = @trains)
    trains.each_with_index { |train, index| puts "#{index + 1}. #{train}" }
  end

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
