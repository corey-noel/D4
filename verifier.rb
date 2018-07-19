require_relative 'char_table.rb'

# opens and reads a file, parsing each line to a block
def read_block_chain filename
  block_chain = []
  File.open(filename).each_with_index do |block, line|
    begin
      block_chain << parse_block(split_block(block))
    rescue ArgumentError => err
      puts "Error on line #{line + 1}: #{err.message}"
      quit -1
    end
  end
  block_chain
end

# takes in a string representation of a block
# returns an array of strings of block parts
# raises an ArgumentError on the wrong number of elements
def split_block str_in
  str_parts = str_in.split("|")
  raise ArgumentError("Block requires 5 elements (got #{str_parts.length})") unless str_parts.length == 5
  str_parts
end

# takes in an array of block parts
# returns a block object
def parse_block str_parts
  block_id = parse_id(str_parts[0])
  prev_hash = parse_hash(str_parts[1])
  transaction_list = parse_transaction_list(str_parts[2])
  seconds, nanoseconds = parse_time_stamp(str_parts[3])
  block_hash = parse_hash(str_parts[4])
  # Block.new TODO

  puts "#" * 20
  puts block_id
  puts prev_hash
  puts transaction_list
  puts seconds
  puts nanoseconds
  puts block_hash
end

# takes in a string representing the ID
# returns an integer ID
# raises an ArgumentError on failure to parse
def parse_id id_str
  begin
    Integer(id_str)
  rescue ArgumentError
    raise ArgumentError("Could not parse ID to an integer")
  end
end

# takes in a string representation of a hash
# returns hex integer of hash
# raises an ArgumentError on failure to parse
def parse_hash hash_in
  begin
    Integer(hash_in, 16)
  rescue ArgumentError
    raise ArgumentError("Could not parse hash")
  end
end

# TODO
def parse_transaction_list transaction_in
  nil
end

# takes in a string representation of a time_stamp
# returns two integers: seconds and nanoseconds
# raises an ArgumentError on failure to parse
def parse_time_stamp ts_in
  ts_parts = ts_in.split(".")
  raise ArgumentError("Timestamp requires 2 parts (got #{ts_parts.length}") unless ts_parts.length == 2
  begin
    return Integer(ts_parts[0]), Integer(ts_parts[1])
  rescue ArgumentError
    raise ArgumentError("Could not parse timestamp")
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

read_block_chain(ARGV[0])
