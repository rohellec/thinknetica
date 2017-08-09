print "Please, enter 3 quotients of quadratic equation: "
a, b, c = gets.split(/,?\s+/).map { |quo| quo.to_f }

discr = b**2 - 4 * a * c
print "Discriminant is #{discr}, "

if discr > 0
  sqrt = Math.sqrt(discr)
  x1 = (-b + sqrt) / 2 * a
  x2 = (-b - sqrt) / 2 * a
  puts "roots: #{x1}, #{x2}"
elsif discr.zero?
  x = -b / 2 * a
  puts "root: #{x}"
else
  puts "there're no roots!"
end
