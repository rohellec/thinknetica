cart = {}
puts "Please, enter product name, price and quantity:"
while line = gets
  line.chomp!
  break if line == "stop"
  product, price, quantity = line.split(/,\s+/)
  cart[product] = { price: price.to_f, quantity: quantity.to_f }
end

puts "Your cart:"
total = 0
cart.each do |product, inner|
  sum = inner[:price] * inner[:quantity]
  total += sum
  printf("%-20s %5.2f %8.2f: %7.2f\n", product, inner[:price], inner[:quantity], sum)
end
puts "Total sum = #{total}"
