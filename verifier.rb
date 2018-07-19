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

def verify_hash(str_parts)
  calculate_hash(str_parts[0..3].join("|"))
end


# PARSE FUNCTIONS
# parses a single block
def parse_block str_in
  str_parts = split_block(str_in)
  block_id = Integer(str_parts[0])
  last_hash = parse_hash(str_parts[1])

  given_hash = parse_hash(str_parts[4])
  verify_hash(str_parts)
end

# parses a hash into an integer
def parse_hash hash_in
  begin
    Integer(hash_in, 16)
  rescue ArgumentError
    raise ArgumentError("Failed to parse hash")
  end
end

def split_block
  str_parts = str_in.split("|")
  raise ArgumentError("Requires 5 elements (received #{str_parts.length})") unless str_parts.length == 5
  str_parts
end
