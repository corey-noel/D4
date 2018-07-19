require_relative 'char_table.rb'

def calculate_hash(str_in, hash_method=:hash_lookup)
  sum = str_in.unpack('U*').map(&method(hash_method)).reduce(:+)
  (sum % 65536).to_s(16)
end

def hash_lookup(char)
  HASHED_VALS[char]
end

def hash_char_val(char)
  (char**2000) * ((char + 2)**21) - ((char + 5)**3)
end

