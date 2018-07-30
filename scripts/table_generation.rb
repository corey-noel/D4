require_relative '../hashing.rb'
require 'json'

puts JSON.generate((0..255).map { |char| hash_char_val(char) % 65536 })
