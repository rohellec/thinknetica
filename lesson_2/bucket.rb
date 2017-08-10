bucket = Hash.new
puts "Please, enter product name, price and quantity:"
while line = gets
  line.chomp!
  break if line == "stop"
  product, price, quantity = line.split(/,\s+/)
  bucket[product] = { price.to_f => quantity.to_f }
end

puts "Your bucket:"
total = 0
bucket.each do |product, inner|
  price = inner.keys.inject(:+)
  quantity = inner.values.inject(:+)
  sum = price * quantity
  total += sum
  printf("%-20s %5.2f %7.2f: %7.2f\n", product, price, quantity, sum)
end
puts "Total sum = #{total}"
