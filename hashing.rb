require_relative 'char_table.rb'


# HASHING FUNCTIONS
# Performs a hash on the entire string
def calculate_hash(str_in, hash_method=:hash_lookup)
  sum = str_in.unpack('U*').map(&method(hash_method)).reduce(:+)
  (sum % 65536).to_s(16)
end

# gets the hash value of a single char via lookup
def hash_lookup(char)
  HASHED_VALS[char]
end

# gets the hash value of a single char via calculation
def hash_char_val(char)
  (char**2000) * ((char + 2)**21) - ((char + 5)**3)
end
