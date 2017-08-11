days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "Please, enter the date (dd-mm-yyy):"
day, month, year = gets.split(/-/).map(&:to_i)
puts day, month, year

if (year % 4).zero? && !(year % 100).zero? || (year % 400).zero?
  days_in_month[1] = 29
end

month -= 1
result = days_in_month[0...month].inject(:+) || 0
result += day
puts "Date number from the start of the year is #{result}"
