def calculate_hash(str_in)
  sum = str_in.unpack('U*').map(&method(:hash_char_val)).reduce(:+)
  (sum % 65536).to_s(16)
end

def hash_char_val(x)
  (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
end
