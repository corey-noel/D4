require_relative 'block.rb'
require_relative 'transaction.rb'

# opens and reads a file, parsing each line to a block
# returns the head of the block_chain
def read_block_chain(filename)
  head = nil
  cur = head

  # this process should be recursive!
  # i will fix this later
  # TODO
  File.open(filename).each_with_index do |block, line|
    begin
      new_block = parse_block(split_block(block))
      if head.nil?
        head = new_block
        cur = new_block
      else
        cur.nxt = new_block
        cur = cur.nxt
      end
    rescue ArgumentError => error
      raise ArgumentError, "Line #{line}: #{error.message}"
    end
  end
  head
end

# takes in a string representation of a block
# returns an array of strings of block parts
# raises an ArgumentError on the wrong number of elements
def split_block(str_in)
  str_parts = str_in.split('|')
  parsing_error("Block requires 5 elements (got #{str_parts.length})") unless str_parts.length == 5
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
  parsing_error("Could not parse ID #{id_str} to an integer")
end

# takes in a string representation of a hash
# returns hex integer of hash
# raises an ArgumentError on failure to parse
def parse_hash(hash_in)
  Integer(hash_in, 16)
rescue ArgumentError
  parsing_error("Could not parse #{hash_in} to a hash")
end

# takes in a string representation of a transaction_list
# returns a list of transaction objects
# raises an ArgumentError for a lot of reasons
def parse_transaction_list(transaction_list_in)
  transaction_list_in.split(':').map { |tran| parse_transaction tran }
end

# takes in a string representation of a transaction
# returns a transaction object
# raises an ArgumentError for a lot of reasons
def parse_transaction(transaction_in)
  exp = /(\w*)>(\w*)\(([\d\.]*)\)/
  res = exp.match(transaction_in)
  parsing_error("Could not parse #{transaction_in} to a transaction") if res.nil? || res.length != 4
  begin
    Transaction.new(res[1], res[2], Integer(res[3]))
  rescue ArgumentError
    parsing_error("Could not parse transaction amount #{res[3]} to an integer")
  end
end

# takes in a string representation of a time_stamp
# returns two integers: seconds and nanoseconds
# raises an ArgumentError on failure to parse
def parse_time_stamp(ts_in)
  ts_parts = ts_in.split('.')
  parsing_error("Timestamp requires 2 parts (got #{ts_parts.length}") unless ts_parts.length == 2
  begin
    return Integer(ts_parts[0]), Integer(ts_parts[1])
  rescue ArgumentError
    parsing_error('Could not parse timestamp')
  end
end

def parsing_error(message)
  raise ArgumentError, message
end
