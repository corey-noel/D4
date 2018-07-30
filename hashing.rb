require_relative 'char_table.rb'

# HASHING FUNCTIONS
# Performs a hash on the entire string
# returns a DECIMAL INTEGER representation
def calculate_hash(str_in, hash_method = :hash_lookup)
  str_in.unpack('U*').map(&method(hash_method)).reduce(:+) % 65536
end

# gets the hash value of a single char via lookup
def hash_lookup(char)
  HASHED_VALS[char]
end

# gets the hash value of a single char via calculation
def hash_char_val(char)
  (char**2000) * ((char + 2)**21) - ((char + 5)**3)
end
