vowels = "aeiou"
vowel_pos = ('a'..'z').each.with_index(1).with_object({}) do |(alpha, index), hash|
  hash[alpha] = index if vowels.include?(alpha)
end

puts vowel_pos
