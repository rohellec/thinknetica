print "Please, enter your name: "
name = gets.chomp.capitalize

print "Please, enter your height: "
height = gets.to_i

weight = height - 110

if weight > 0
  puts "Hi, #{name}! Yor ideal weight is #{weight}"
else
  puts "Hi, #{name}! You already have optimal weight"
end
