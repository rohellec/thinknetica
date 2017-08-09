print "Please, enter the lengths of all triangle sides: "

side_a, side_b, side_c = gets.split(/,?\s+/).map { |side| side.to_f }.sort

if side_c**2 == side_a**2 + side_b**2
  result = "The triangle is rectangular"
  result += " and isosceles" if side_a == side_b
  puts result
elsif (side_a == side_b && side_b != side_c) ||
      (side_a == side_c && side_b != side_c) ||
      (side_b == side_c && side_a != side_b)
  puts "The triangle is isosceles"
elsif side_a == side_b && side_b == side_c
  puts "The triangle is equilateral"
else
  puts "The triangle is pretty simple and has no features"
end
