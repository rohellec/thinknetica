print "Please, enter the base and the height of the triangle accordingly: "
base, height = gets.split(/,?\s+/).map { |side| side.to_f }

area = 0.5 * base * height

puts "The square of the triangle is #{area}"
