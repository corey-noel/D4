require_relative 'block.rb'
require_relative 'transaction.rb'

# opens and reads a file, parsing each line to a block
def read_block_chain(filename)
  block_chain = []
  File.open(filename).each_with_index do |block, line|
    begin
      block_chain << parse_block(split_block(block))
    rescue ArgumentError => err
      puts "Parse error line #{line + 1}: #{err.message}"
      quit -1
    end
  end
  block_chain
end

# takes in a string representation of a block
# returns an array of strings of block parts
# raises an ArgumentError on the wrong number of elements
def split_block(str_in)
  str_parts = str_in.split('|')
  raise ArgumentError("Block requires 5 elements (got #{str_parts.length})") unless str_parts.length == 5
  str_parts
end

# takes in an array of block parts
# returns a block object
def parse_block(str_parts)
  block_id = parse_id(str_parts[0])
  prev_hash = parse_hash(str_parts[1])
  transaction_list = parse_transaction_list(str_parts[2])
  seconds, nanoseconds = parse_time_stamp(str_parts[3])
  block_hash = parse_hash(str_parts[4])
  Block.new(block_id, prev_hash, transaction_list, seconds, nanoseconds, block_hash)
end

# takes in a string representing the ID
# returns an integer ID
# raises an ArgumentError on failure to parse
def parse_id(id_str)
  Integer(id_str)
rescue ArgumentError
  raise ArgumentError('Could not parse ID to an integer')
end

# takes in a string representation of a hash
# returns hex integer of hash
# raises an ArgumentError on failure to parse
def parse_hash(hash_in)
  Integer(hash_in, 16)
rescue ArgumentError
  raise ArgumentError('Could not parse hash')
end

# takes in a string representation of a transaction_list
# returns a list of transaction objects
# raises an ArgumentError for a lot of reasons
def parse_transaction_list(transaction_list_in)
  transaction_list_in.split(":").map{ |tran| parse_transaction tran }
end


# takes in a string representation of a transaction
# returns a transaction object
# raises an ArgumentError for a lot of reasons
def parse_transaction(transaction_in)
  exp = /(\w*)>(\w*)\(([\d\.]*)\)/
  res = exp.match(transaction_in)
  raise ArgumentError('Could not parse transaction #{transaction_in}') unless res.length == 4
  Transaction.new(res[1], res[2], res[3])
end

# takes in a string representation of a time_stamp
# returns two integers: seconds and nanoseconds
# raises an ArgumentError on failure to parse
def parse_time_stamp(ts_in)
  ts_parts = ts_in.split('.')
  raise ArgumentError("Timestamp requires 2 parts (got #{ts_parts.length}") unless ts_parts.length == 2
  begin
    return Integer(ts_parts[0]), Integer(ts_parts[1])
  rescue ArgumentError
    raise ArgumentError('Could not parse timestamp')
  end
end
