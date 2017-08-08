print "Please, enter the first quotient of quadratic equation: "
a = gets.to_f

print "Please, enter the second quotient of quadratic equation: "
b = gets.to_f

print "Please, enter the third quotient of quadratic equation: "
c = gets.to_f

discr = b**2 - 4 * a * c
sqrt = Math.sqrt(discr)
print "Discriminant is #{discr}, "

if discr > 0
  x1 = (-b + sqrt) / 2 * a
  x2 = (-b - sqrt) / 2 * a
  puts "roots: #{x1}, #{x2}"
elsif discr.zero?
  x = -b / 2 * a
  puts "root: #{x}"
else
  puts "there're no roots!"
end
