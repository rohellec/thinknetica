days_in_month = {
  1  => 31,
  2  => 28,
  3  => 31,
  4  => 30,
  5  => 31,
  6  => 30,
  7  => 31,
  8  => 31,
  9  => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

puts "Please, enter the date (dd-mm-yyy):"
day, month, year = gets.split(%r{(,?\s+)|-|:|/}).map(&:to_i)

if (year % 4).zero? && !(year % 100).zero? || (year % 400).zero?
  days_in_month[2] = 29
end

result = 0
(1...month).each { |i| result += days_in_month[i] }
result += day
puts "Date number from the start of the year is #{result}"
