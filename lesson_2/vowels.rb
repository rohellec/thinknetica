vowels = "aeiou"
vowel_pos = Hash.new
('a'..'z').each.with_index(1) do |alpha, index|
  vowel_pos[alpha] = index if vowels.include?(alpha)
end

puts vowel_pos
