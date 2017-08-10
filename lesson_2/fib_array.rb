arr = []
i1, i2 = 1, 1
while i1 < 100
  arr << i1
  i1, i2 = i2, i1 + i2
end

puts "Fibonacci array:\n#{arr}"
