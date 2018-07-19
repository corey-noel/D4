require_relative 'char_table.rb'

# opens and reads a file, parsing each line to a block
def read_block_chain filename
  line_num = 1
  block_chain = []
  File.open(filename).each do |block|
    begin
      block_chain << parse_block split_block block
      line_num += 1
    rescue ArgumentError => err
      puts "Error on line #{line_num}: #{err.message}"
    end
  end
  block_chain
end

# takes in a string representation of a block
# returns an array of strings of block parts
# raises an error on the wrong number of elements
def split_block str_in
  str_parts = str_in.split("|")
  raise ArgumentError("Requires 5 elements (received #{str_parts.length})") unless str_parts.length == 5
  str_parts
end

# takes in an array of block parts
# returns a block object
def parse_block str_parts
  block_id = parse_id(str_parts[0])
  prev_hash = parse_hash(str_parts[1])
  transaction_list = nil #TODO
  time_stamp = nil #TODO
  block_hash = parse_hash(str_parts[4])
  # Block.new TODO
end

# takes in a string representing the ID
# returns an integer ID
# raises an error on failure to parse
def parse_id id_str
  begin
    Integer(id_str)
  rescue ArgumentError
    raise ArgumentError("Could not parse ID to an integer")
  end
end

# takes in a string representation of a hash
# returns hex integer of hash
# raises an error on failure to parse
def parse_hash hash_in
  begin
    Integer(hash_in, 16)
  rescue ArgumentError
    raise ArgumentError("Failed to parse hash")
  end
end

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
