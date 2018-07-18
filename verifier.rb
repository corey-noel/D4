def calculate_hash(str_in)
  sum = str_in.unpack('U*').map(&method(:hash_char_val)).reduce(:+)
  (sum % 65536).to_s(16)
end

def hash_char_val(x)
  (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
end

str_in = "8|e01d|Sam>John(3):Joe>Sam(4):SYSTEM>Rana(100)|1518839370.605237540"
puts calculate_hash str_in
