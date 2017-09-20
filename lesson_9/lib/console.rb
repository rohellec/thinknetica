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

  CREATE_TRAIN_OPTIONS = {
    cargo:     :create_cargo_train,
    passenger: :create_passenger_train
  }

  MAIN_MENU_ACTIONS = {
    1 => :station_creation,
    2 => :train_creation,
    3 => :route_menu,
    4 => :assign_route,
    5 => :hook_wagon,
    6 => :unhook_wagon,
    7 => :move_train,
    8 => :display_stations,
    9 => :wagon_menu
  }

  MAIN_MENU_PROMPT = <<-SUMMARY
    Main menu
    1. Create station
    2. Create train
    3. Route management
    4. Assign route to train
    5. Hook wagon to the train
    6. Unhook wagon from the train
    7. Move the train along the route
    8. Display stations and trains on them
    9. Take seat or volume in wagon
    0. Quit
  SUMMARY

  MOVE_MENU_ACTIONS = {
    1 => :move_train_forward,
    2 => :move_train_backward,
    3 => :move_train,
    4 => :main_menu
  }

  MOVE_MENU_PROMPT = <<-SUMMARY
    1. Move train forward
    2. Move train backward
    3. Choose another train
    4. Main menu
  SUMMARY

  ROUTE_MENU_ACTIONS = {
    1 => :route_creation,
    2 => :add_stations_to_route,
    3 => :remove_stations_from_route,
    4 => :main_menu
  }

  ROUTE_MENU_PROMPT = <<-SUMMARY
    Route menu
    1. Create route
    2. Add stations to route
    3. Remove stations from route
    4. Main menu
  SUMMARY

  TRAIN_TYPES_ACTIONS = {
    1 => :cargo,
    2 => :passenger,
    3 => :all
  }

  TRAIN_TYPES_PROMPT = <<-SUMMARY
    Trains of which type do you want to see:
    1. Cargo
    2. Passenger
    3. All
  SUMMARY

  attr_reader :stations, :trains, :routes

  def main_menu
    loop do
      main_menu_prompt
      input = gets.to_i
      system("clear")
      return if input.zero?
      main_menu_action(input)
    end
  rescue KeyError
    wrong_input
    retry
  end

  def main_menu_prompt
    puts MAIN_MENU_PROMPT
    print "Please, choose the action:\n>"
  end

  def main_menu_action(key)
    action = MAIN_MENU_ACTIONS.fetch(key)
    send(action)
  end

  def station_creation
    station = create_station
    system("clear")
    stations << station
    puts "Station #{station} has been created!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def create_station
    print "Please, enter the name of the station:\n>"
    name = gets.chomp
    Station.new(name)
  end

  def train_creation
    train = create_train
    trains << train
    system("clear")
    puts "#{train.to_s.capitalize} has been created!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def create_train
    print "Please, enter the type of the train:\n>"
    type = gets.chomp.downcase.to_sym
    action = CREATE_TRAIN_OPTIONS.fetch(type)
    send(action)
  rescue KeyError
    wrong_input
    retry
  end

  def create_cargo_train
    print "Please, enter the number of the train:\n>"
    number = gets.chomp
    CargoTrain.new(number)
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def create_passenger_train
    print "Please, enter the number of the train:\n>"
    number = gets.chomp
    PassengerTrain.new(number)
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def route_menu
    loop do
      key = route_menu_prompt
      action = ROUTE_MENU_ACTIONS.fetch(key)
      return if action == :main_menu
      send(action)
    end
  rescue KeyError
    wrong_input
    retry
  end

  def route_menu_prompt
    puts ROUTE_MENU_PROMPT
    print "Please, choose the action:\n>"
    input = gets.to_i
    system("clear")
    input
  end

  def route_creation
    check_stations_quantity
    route = create_route
    routes << route
    system("clear")
    puts "Route #{route} has been created!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def check_stations_quantity
    while stations.size < 2
      puts "There should be at least 2 stations before you can create the route " \
           "- #{2 - stations.size} more left."
      print "Do you want to create the station? (Y/n)\n>"
      input = gets.chomp.downcase
      break unless input.empty? || input =~ "y"
      station_creation
    end
  end

  def create_route
    list_stations
    print "Please, enter the indexes of the base and final stations accordingly:\n>"
    base, final = int_array_input.map { |i| stations[i - 1] }
    Route.new(base, final)
  end

  def add_stations_to_route
    route = choose_route
    prompt_message = "Please, enter the indexes of stations you want to add"
    input_stations = stations_from_prompt(prompt_message)
    input_stations.each { |station| route.add(station) }
    system("clear")
    puts "Stations #{input_stations.join(', ')} have been added to the route #{route}!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def remove_stations_from_route
    route = choose_route
    removal_stations = delete_stations_from(route)
    puts "Stations #{removal_stations.join(", ")} have been removed from the route #{route}!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def delete_stations_from(route)
    prompt_message = "Please, enter the indexes of stations you want to remove"
    removal_stations = stations_from_prompt(prompt_message, route.stations)
    stations_with_trains = removal_stations.map { |station| station.trains.any? }
    removal_stations -= stations_with_trains
    if stations_with_trains.any?
      puts "There are trains on stations #{stations_with_trains.join(', ')}, " \
           "they won't be removed from the route!"
    end
    removal_stations.each { |station| route.delete(station) }
    removal_stations
  end

  def assign_route(train = nil)
    train = choose_train unless train
    route = choose_route
    train.assign_route(route)
    puts "Route #{route} has been assigned to #{train}!"
  end

  def hook_wagon
    train = choose_train
    wagon = create_wagon_by_type(train.type)
    train.hook_wagon(wagon)
    system("clear")
    puts "Wagon №#{wagon.number} has been hooked to the #{train}!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def create_wagon_by_type(type)
    print "Please, enter the wagon number you want to hook to the train:\n>"
    number = gets.to_i
    system("clear")
    case type
    when :cargo
      create_cargo_wagon(number)
    when :passenger
      create_passenger_wagon(number)
    end
  end

  def create_cargo_wagon(number)
    print "Please, enter the total volume of the wagon:\n>"
    volume = gets.to_i
    system("clear")
    CargoWagon.new(number, volume)
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def create_passenger_wagon(number)
    print "Please, enter the number of seats in the wagon:\n>"
    seats = gets.to_i
    system("clear")
    PassengerWagon.new(number, seats)
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def unhook_wagon
    train = choose_train
    removal_wagons = wagons_to_remove_from(train)
    removal_wagons.each { |wagon| train.unhook_wagon(wagon) }
    puts "Wagons #{removal_wagons.map(&:number).join(", ")} have been unhooked from the #{train}!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def wagons_to_remove_from(train)
    input_wagons = []
    while input_wagons.empty?
      list_wagons(train)
      print "Please, enter the indexes of wagons you want to unhook:\n>"
      input_wagons = int_array_input.map { |i| train.wagons[i - 1] }
      system("clear")
      return input_wagons unless input_wagons.empty?
      puts "There were no wagons chosen. Please, try again."
    end
  end

  def move_train
    train = choose_train
    unless train.route
      puts "Sorry, you need to assign route to this train first!"
      print "Do you want to assign route? (Y/n)\n>"
      input = gets.chomp.downcase
      return unless input.empty? || input =~ "y"
      assign_route(train)
    end
    move_menu(train)
  end

  def move_menu(train)
    loop do
      input = move_menu_prompt(train)
      action = MOVE_MENU_ACTIONS.fetch(input)
      break if action == :main_menu
      send(action, train)
    end
  rescue KeyError
    wrong_input
    retry
  end

  def move_menu_prompt(train)
    puts "#{train.to_s.capitalize} route menu:"
    puts MOVE_MENU_PROMPT
    print "Please, choose the action:\n>"
    input = gets.to_i
    system("clear")
    input
  end

  def move_train_forward(train)
    train.move_next
    puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
  rescue => e
    puts e.message
  end

  def move_train_backward(train)
    train.move_back
    puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
  rescue => e
    puts e.message
  end

  def display_stations
    unless stations.any?
      puts "There no stations added yet!"
      return
    end
    loop do
      station = choose_station
      break if station.nil?
      display_trains(station)
    end
  end

  def choose_station
    message = "Please, enter the index of station you want to inspect or press 'q' to return back:"
    loop do
      list_stations
      input = input_prompt(message)
      return nil if input == 'q'
      index = input.to_i - 1
      return stations[index] if stations[index]
      wrong_input
    end
  end

  def display_trains(station)
    unless station.trains.any?
      puts "There no trains on selected station!"
      return
    end
    type = choose_train_type
    loop do
      train = choose_train_from(station, type)
      break if train.nil?
      display_wagons(train)
    end
  end

  def choose_train_type
    loop do
      key = choose_train_type_prompt
      type = TRAIN_TYPES_ACTIONS.fetch(key)
      type == :all ? nil : type
    end
  rescue KeyError
    wrong_input
    retry
  end

  def choose_train_type_prompt
    puts TRAIN_TYPES_PROMPT
    print "Please, choose the type:\n>"
    input = gets.to_i
    system("clear")
    input
  end

  def choose_train_from(station, type)
    message = "Please, enter the index of train you want to inspect or press 'q' to return back>"
    loop do
      puts "#{type ? type.capitalize : 'All'} trains on station #{station}:"
      station.display_trains(type)
      input = input_prompt(message)
      return nil if input == 'q'
      index = input.to_i - 1
      return trains[index] if trains[index]
      wrong_input
    end
  end

  def display_wagons(train)
    unless train.wagons.any?
      puts "There no wagons for selected train!"
      return
    end
    list_wagons(train)
    print "Please, press enter to return back:\n>"
    gets
    system("clear")
  end

  def wagon_menu
    loop do
      train = choose_train
      if train.wagons.any?
        wagon = choose_wagon_from(train)
        fill_wagon_by_type(wagon)
        break
      else
        puts "#{train.to_s.capitalize} doesn't have any wagons. Please choose another one."
      end
    end
  end

  def fill_wagon_by_type(wagon)
    case wagon.type
    when :cargo
      fill_cargo_wagon(wagon)
    when :passenger
      fill_passenger_wagon(wagon)
    end
  end

  def fill_cargo_wagon(wagon)
    puts "How much volume do you want to fill?"
    volume = gets.to_f
    system("clear")
    wagon.take_volume(volume)
    puts wagon
  rescue => e
    puts e.message
    system("clear")
    retry
  end

  def fill_passenger_wagon(wagon)
    wagon.take_seat
    puts wagon
  rescue => e
    puts e.message
    system("clear")
  end

  def choose_route
    loop do
      list_routes
      print "Please, choose the route:\n>"
      route = routes[gets.to_i - 1]
      system("clear")
      return route if route
      wrong_input
    end
  end

  def choose_train
    loop do
      puts "List of trains:"
      list_trains
      print "Please, choose the train:\n>"
      train = trains[gets.to_i - 1]
      system("clear")
      return train if train
      wrong_input
    end
  end

  def choose_wagon_from(train)
    loop do
      puts "List of wagons in the #{train}:"
      list_wagons(train)
      print "Please, choose the wagon:\n>"
      wagon = train.wagons[gets.to_i - 1]
      system("clear")
      return wagon if wagon
      wrong_input
    end
  end

  def stations_from_prompt(prompt_message, stations = @stations)
    input_stations = []
    while input_stations.empty?
      list_stations(stations)
      print "#{prompt_message}:\n>"
      input_stations = int_array_input.map { |i| stations[i - 1] }
      system("clear")
      return input_stations unless input_stations.empty?
      puts "There were no stations chosen from the list. Please, try again."
    end
  end

  def input_prompt(prompt_message)
    print "#{prompt_message}:\n>"
    input = gets.chomp.downcase
    system("clear")
    input
  end

  def int_array_input
    gets.chomp.split(/\W+/).map(&:to_i)
  end

  def list_routes
    puts "List of routes:"
    routes.each.with_index(1) { |route, index| puts "#{index}. Route #{route}" }
  end

  def list_stations(stations = @stations)
    puts "List of stations:"
    stations.each.with_index(1) { |station, index| puts "#{index}. #{station}" }
  end

  def list_trains(trains = @trains)
    trains.each.with_index(1) { |train, index| puts "#{index}. #{train.format}" }
  end

  def list_wagons(train)
    train.each_wagon.with_index(1) { |wagon, index| puts "#{index}. #{wagon}" }
  end

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
