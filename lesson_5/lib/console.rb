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
      when 1
        create_station
      when 2
        create_train
      when 3
        route_menu
      when 4
        assign_route
      when 5
        hook_wagon
      when 6
        unhook_wagon
      when 7
        move_train
      when 8
        display_stations
      when 0
        break
      else
        wrong_input
      end
    end
  end

  def create_station
    system("clear")
    name = string_input("Please, enter the name of the station:")
    station = Station.new(name)
    stations << station
    system("clear")
    puts "Station #{station} has been created!"
  end

  def create_train
    system("clear")
    type = gets_train_type
    number = string_input("Please, enter the number of the train:")
    case type
    when :cargo
      train = CargoTrain.new(number)
    when :passenger
      train = PassengerTrain.new(number)
    end
    trains << train
    system("clear")
    puts "#{train.to_s.capitalize} has been created!"
  end

  def gets_train_type
    loop do
      puts "What type of train do you want to create?"
      puts "1. Cargo"
      puts "2. Passenger"
      puts "Please, choose the type:"
      print ">"
      input = gets.to_i
      system("clear")
      case input
      when 1
        return :cargo
      when 2
        return :passenger
      else
        wrong_input
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
      system("clear")
      case input
      when 1
        create_route
      when 2
        add_stations_to_route
      when 3
        remove_stations_from_route
      when 4
        break
      else
        wrong_input
      end
    end
  end

  def create_route
    check_stations_quantity
    base, final = stations_from_list("Please, enter the indexes of the base " \
      "and final stations accordingly:")
    route = Route.new(base, final)
    routes << route
    system("clear")
    puts "Route #{route} has been created!"
  end

  def add_stations_to_route
    route = choose_route
    input_stations = stations_from_list("Please, enter the indexes of stations you want to add:")
    input_stations.each { |station| route.add(station) }
    system("clear")
    puts "Stations #{input_stations.join(", ")} have been added to the route #{route}!"
  end

  def remove_stations_from_route
    route = choose_route
    removal_stations = stations_to_remove_from(route.stations)
    removal_stations.each { |station | route.delete(station) }
    system("clear")
    puts "Stations #{removal_stations.join(", ")} have been removed from the route #{route}!"
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
    wagon_number = int_input("Please, enter the wagon number you want to hook to the train:")
    case train.type
    when :cargo
      wagon = CargoWagon.new(wagon_number)
    when :passenger
      wagon = PassengerWagon.new(wagon_number)
    end
    train.hook_wagon(wagon)
    system("clear")
    puts "Wagon #{wagon} has been hooked to the #{train}!"
  end

  def unhook_wagon
    system("clear")
    train = choose_train
    removal_wagons = wagons_to_remove_from(train)
    removal_wagons.each { |wagon| train.unhook_wagon(wagon) }
    system("clear")
    puts "Wagons #{removal_wagons.join(", ")} have been unhooked from the #{train}!"
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
      system("clear")
      case input
      when 1
        move_train_forward(train)
      when 2
        move_train_backward(train)
      when 3
        move_train
      when 4
        break
      else
        wrong_input
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
    type = choose_train_type
    system("clear")
    puts "#{type ? type.capitalize : 'All'} trains on station #{station}"
    list_trains(station.trains(type))
    print "Press enter to return to main menu:\n>"
    gets
    system("clear")
  end

  def check_stations_for_trains(stations)
    stations.each do |station|
      if station.trains.any?
        stations.delete(station)
        puts "There are trains on station #{station}, it won't be removed from the route!"
      end
    end
  end

  def check_stations_quantity
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

  def choose_train_type
    loop do
      puts "Trains of which type do you want to see:"
      puts "1. Cargo"
      puts "2. Passenger"
      puts "3. All"
      puts "Please, choose the type:"
      print ">"
      input = gets.to_i
      case input
      when 1
        return :cargo
      when 2
        return :passenger
      when 3
        return nil
      else
        wrong_input
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

  def int_array_input
    gets.chomp.split(/\W+/).map(&:to_i)
  end

  def int_input(prompt_message)
    result = 0
    while result.zero?
      puts prompt_message
      print ">"
      result = gets.to_i
      wrong_input if result.zero?
    end
    result
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
    trains.each_with_index { |train, index| puts "#{index + 1}. #{train.to_s.capitalize}" }
  end

  def list_wagons(train)
    train.wagons.each_with_index { |wagon, index| puts "#{index + 1}. Wagon #{wagon}" }
  end

  def stations_from_list(stations = @stations, prompt_message)
    input_stations = []
    while input_stations.empty?
      list_stations(stations)
      puts prompt_message
      print ">"
      input_stations = int_array_input.map { |i| stations[i - 1] }
      wrong_input if input_stations.empty?
    end
    input_stations
  end

  def stations_to_remove_from(stations)
    input_stations = []
    while input_stations.empty?
      list_stations(stations)
      puts "Please, enter the indexes of stations you want to remove:"
      print ">"
      input_stations = int_array_input.map { |i| stations[i - 1] }
      system("clear")
      next if input_stations.empty?
      check_stations_for_trains(input_stations)
    end
    input_stations
  end

  def string_input(prompt_message)
    result = ''
    while result.empty?
      puts prompt_message
      print ">"
      result = gets.chomp
      wrong_input if result.empty?
    end
    result
  end

  def wagons_to_remove_from(train)
    input_wagons = []
    while input_wagons.empty?
      list_wagons(train)
      puts "Please, enter the indexes of wagons you want to unhook:"
      print ">"
      input_wagons = int_array_input.map { |i| train.wagons[i - 1] }
      wrong_input if input_wagons.empty?
    end
    input_wagons
  end

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
