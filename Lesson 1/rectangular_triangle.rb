print "Please, enter the length of the first side of the triangle: "
side_a = gets.to_f

print "Please, enter the length of the second side of the triangle: "
side_b = gets.to_f

print "Please, enter the length of the third side of the triangle: "
side_c = gets.to_f

if side_a > side_b && side_a > side_c
  hypotenuse, cathetus_a, cathetus_b = side_a, side_b, side_c
elsif side_b > side_a && side_b > side_c
  hypotenuse, cathetus_a, cathetus_b = side_b, side_a, side_c
else
  hypotenuse, cathetus_a, cathetus_b = side_c, side_a, side_b
end

if hypotenuse**2 == cathetus_a**2 + cathetus_b**2
  result = "The triangle is rectangular"
  result += " and isosceles" if cathetus_a == cathetus_b
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
