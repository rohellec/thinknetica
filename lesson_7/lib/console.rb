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
      puts "9. Take seat or volume in wagon"
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
      when 9
        wagon_menu
      when 0
        break
      else
        wrong_input
      end
    end
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
    loop do
      print "Please, enter the type of the train:\n>"
      type = gets.chomp.downcase.to_sym
      case type
      when :cargo
        create_cargo_train
        break
      when :passenger
        create_passenger_train
        break
      else
        wrong_input
      end
    end
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
    route = create_route
    routes << route
    system("clear")
    puts "Route #{route} has been created!"
  rescue => e
    system("clear")
    puts e.message
    retry
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
    input_stations = enter_stations_with_prompt(prompt_message)
    input_stations.each { |station| route.add(station) }
    system("clear")
    puts "Stations #{input_stations.join(", ")} have been added to the route #{route}!"
  rescue => e
    system("clear")
    puts e.message
    retry
  end

  def remove_stations_from_route
    route = choose_route
    prompt_message = "Please, enter the indexes of stations you want to remove"
    removal_stations = enter_stations_with_prompt(prompt_message)
    delete_stations_with_trains(removal_stations)
    removal_stations.each { |station | route.delete(station) }
    system("clear")
    puts "Stations #{removal_stations.join(", ")} have been removed from the route #{route}!"
  rescue => e
    system("clear")
    puts e.message
    retry
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
    puts "Wagons #{removal_wagons.join(", ")} have been unhooked from the #{train}!"
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
    puts "#{train.to_s.capitalize} route menu:"
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
    loop do
      list_stations
      station = choose_station
      break if station.nil?
      if station.trains.any?
        display_trains(station)
      else
        puts "There no trains on selected station!"
      end
    end
  end

  def choose_station
    loop do
      print "Please, enter the index of station you want to inspect or press 'q' to return back:\n>"
      input = gets.chomp.downcase
      system("clear")
      return nil if input == 'q'
      index = input.to_i - 1
      return stations[index] if stations[index]
      wrong_input
      list_stations
    end
  end

  def display_trains(station)
    type = choose_train_type
    loop do
      puts "#{type ? type.capitalize : 'All'} trains on station #{station}"
      station.each_train(type).with_index(1) { |train, index| puts "#{index}. #{train.format}" }
      train = choose_train_from(station.trains(type))
      break if train.nil?
      if train.wagons.any?
        display_wagons(train)
      else
        puts "There no wagons for selected train!"
      end
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

  def choose_train_from(trains)
    loop do
      print "Please, enter the index of train you want to inspect or press 'q' to return back:\n>"
      input = gets.chomp.downcase
      system("clear")
      return nil if input == 'q'
      index = input.to_i - 1
      return trains[index] if trains[index]
      wrong_input
      list_trains(trains)
    end
  end

  def display_wagons(train)
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
  rescue => e
    puts e.message
    system("clear")
    retry
  end

  def fill_passenger_wagon(wagon)
    wagon.take_seat
  rescue => e
    puts e.message
    system("clear")
  end

  def check_stations_quantity
    while stations.size < 2
      puts "There should be at least 2 stations before you can create the route - #{2 - stations.size} more left."
      print "Do you want to create the station? (Y/n)\n>"
      input = gets.chomp.downcase
      break unless input.empty? || input =~ "y"
      station_creation
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

  def choose_wagon_from(train)
    loop do
      puts "List of wagons in the #{train}:"
      list_wagons(train)
      print "Please, choose the wagon:\n>"
      wagon = train.wagons[gets.to_i - 1]
      if wagon
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
    routes.each.with_index(1) { |route, index| puts "#{index + 1}. Route #{route}" }
  end

  def list_stations(stations = @stations)
    puts "List of stations:"
    stations.each.with_index(1) { |station, index| puts "#{index + 1}. #{station}" }
  end

  def list_trains(trains = @trains)
    trains.each.with_index(1) { |train, index| puts "#{index + 1}. #{train.format}" }
  end

  def list_wagons(train)
    train.each_wagon.with_index(1) { |wagon, index| puts "#{index + 1}. #{wagon}" }
  end

  def wrong_input
    system("clear")
    puts "Wrong input! Please, try again."
  end
end
