require_relative 'verifier.rb'

hashed_vals = []
(0..255).each do |char|
  hashed_vals << hash_char_val(char) % 65536
end

puts "HASHED_VALS = ["
puts hashed_vals.join(",\n")
puts "]"
