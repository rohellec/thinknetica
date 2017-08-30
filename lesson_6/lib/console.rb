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
      print "Please, choose the action:\n>"
      input = gets.to_i
      system("clear")
      case input
      when 1
        station_creation
      when 2
        train_creation
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

  def station_creation
    begin
      station = create_station
    rescue e
      system("clear")
      puts e.message
      retry
    end
    system("clear")
    stations << station
    puts "Station #{station} has been created!"
  end
    
  def create_station
    print "Please, enter the name of the station:\n>"
    name = gets.chomp
    station = Station.new(name)
    station
  end

  def train_creation
    begin
      train = create_train
    rescue e
      system("clear")
      puts e.message
      retry
    end
    trains << train
    system("clear")
    puts "#{train.to_s.capitalize} has been created!"
  end

  def create_train
    print "Please, enter the number of the train:\n>"
    number = gets.chomp
    print "Please, enter the type of the train:\n>"
    type = gets.chomp.downcase.to_sym
    case type
    when :cargo
      train = CargoTrain.new(number)
    when :passenger
      train = PassengerTrain.new(number)
    end
    train
  end

  def route_menu
    loop do
      puts "Route menu"
      puts "1. Create route"
      puts "2. Add stations to route"
      puts "3. Remove stations from route"
      puts "4. Main menu"
      print "Please, choose the action:\n>"
      input = gets.to_i
      system("clear")
      case input
      when 1
        route_creation
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

  def route_creation
    check_stations_quantity
    begin
      route = create_route
    rescue e
      system("clear")
      puts e.message
      retry
    end
    routes << route
    system("clear")
    puts "Route #{route} has been created!"
  end

  def create_route
    list_stations
    print "Please, enter the indexes of the base and final stations accordingly:\n>"
    base, final = int_array_input.map { |i| stations[i - 1] }
    Route.new(base, final)
  end

  def add_stations_to_route
    route = choose_route
    begin
      prompt_message = "Please, enter the indexes of stations you want to add>"
      input_stations = enter_stations_with_prompt(prompt_message)
      input_stations.each { |station| route.add(station) }
    rescue e
      system("clear")
      puts e.message
      retry
    end
    system("clear")
    puts "Stations #{input_stations.join(", ")} have been added to the route #{route}!"
  end

  def remove_stations_from_route
    route = choose_route
    begin
      prompt_message = "Please, enter the indexes of stations you want to remove"
      removal_stations = enter_stations_with_prompt(prompt_message)
      delete_stations_with_trains(removal_stations)
      removal_stations.each { |station | route.delete(station) }
    rescue e
      system("clear")
      puts e.message
      retry
    end
    system("clear")
    puts "Stations #{removal_stations.join(", ")} have been removed from the route #{route}!"
  end

  def assign_route(train = nil)
    train = choose_train unless train
    route = choose_route
    train.assign_route(route)
    puts "Route #{route} has been assigned to #{train}!"
  end

  def hook_wagon
    train = choose_train
    begin
      wagon = create_wagon_by_type(train.type)
    rescue
      system("clear")
      puts e.message
      retry
    end
    train.hook_wagon(wagon)
    system("clear")
    puts "Wagon #{wagon} has been hooked to the #{train}!"
  end

  def create_wagon_by_type(type)
    print "Please, enter the wagon number you want to hook to the train:\n>"
    number = gets.to_i
    case type
    when :cargo
      wagon = CargoWagon.new(number)
    when :passenger
      wagon = PassengerWagon.new(number)
    end
    wagon
  end

  def unhook_wagon
    train = choose_train
    begin
      removal_wagons = wagons_to_remove_from(train)
      removal_wagons.each { |wagon| train.unhook_wagon(wagon) }
    rescue e
      system("clear")
      puts e.message
      retry
    end
    puts "Wagons #{removal_wagons.join(", ")} have been unhooked from the #{train}!"
  end

  def wagons_to_remove_from(train)
    input_wagons = []
    while input_wagons.empty?
      list_wagons(train)
      print "Please, enter the indexes of wagons you want to unhook:\n>"
      input_wagons = int_array_input.map { |i| train.wagons[i - 1] }
      if input_wagons.empty?
        puts "There were no wagons chosen from the train. Please, try again." 
      end
    end
    input_wagons
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
    puts "Train #{train} route menu:"
    loop do
      puts "1. Move train forward"
      puts "2. Move train backward"
      puts "3. Choose another train"
      puts "4. Main menu"
      print "Please, choose the action:\n>"
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
    train.move_next
    puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
  rescue e
    puts e.message
  end

  def move_train_backward(train)
    train.move_back
    puts "#{train.to_s.capitalize} has moved to station #{train.current_station}!"
  rescue e
    puts e.message
  end

  def display_stations
    station = choose_station
    type = choose_train_type
    system("clear")
    puts "#{type ? type.capitalize : 'All'} trains on station #{station}"
    list_trains(station.trains(type))
    print "Press enter to return to main menu:\n>"
    gets
    system("clear")
  end

  def check_stations_quantity
    return if stations.size >= 2
    while stations.size < 2
      puts "There should be at least 2 stations before you can create the route - #{2 - stations.size} more left."
      print "Do you want to create the station? (Y/n)\n>"
      input = gets.chomp.downcase
      break unless input.empty? || input =~ "y"
      station_creation
    end
  end

  def choose_train_type
    loop do
      puts "Trains of which type do you want to see:"
      puts "1. Cargo"
      puts "2. Passenger"
      puts "3. All"
      print "Please, choose the type:\n>"
      input = gets.to_i
      system("clear")
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
      print "Please, choose the route:\n>"
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
      print "Please, choose the station:\n>"
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
      print "Please, choose the train:\n>"
      train = trains[gets.to_i - 1]
      if train
        system("clear")
        return train
      else
        wrong_input
      end
    end
  end

  def delete_stations_with_trains(stations)
    removal_stations = stations.map { |station| station.trains.any? }
    stations -= removal_stations
    puts "There are trains on stations #{removal_stations.join(', ')}, they won't be removed from the route!"
  end

  def enter_stations_with_prompt(prompt_message)
    input_stations = []
    while input_stations.empty?
      list_stations(stations)
      print "#{prompt_message}:\n>"
      input_stations = int_array_input.map { |i| stations[i - 1] }
      if input_stations.empty?
        puts "There were no stations chosen from the list. Please, try again." 
      end
    end
    input_stations
  end

  def int_array_input
    gets.chomp.split(/\W+/).map(&:to_i)
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

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
