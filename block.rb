require_relative 'hashing.rb'

class Block
  attr_accessor :nxt
  attr_reader :id, :prev_hash, :transaction_list, :seconds, :nanoseconds, :block_hash

  def initialize(id, prev_hash, transaction_list, seconds, nanoseconds, block_hash)
    @id = id
    @prev_hash = prev_hash
    @transaction_list = transaction_list
    @seconds = seconds
    @nanoseconds = nanoseconds
    @block_hash = block_hash

    @nxt = nil
  end

##### FIRST BLOCK VERIFICATIONS #####
  # recursively verify the block_chain
  # treats this block as the head
  # called externally only
  def verify_block_chain
    verify_first_id
    verify_first_prev_hash
    verify_first_transaction_list

    # TODO add first block transactions to dict
    verify_block({})
  end

  # @id of first block = 0
  def verify_first_id
    err(0, "First id must be 0") unless @id == 0
  end

  # @prev_hash of first block = 0
  def verify_first_prev_hash
    err(0, "First prev_hash must be 0") unless @prev_hash == 0
  end

  # first block transaction list
  # not sure what we need to check here
  def verify_first_transaction_list
    # TODO
  end

##### ALL BLOCK VERIFICATIONS #####
  # recursively verify the block_chain
  # wallets is a dictionary of amounts of billcoin each individual has
  # called internally only
  def verify_block(wallets)
    # we always do these steps
    # wallet amounts are all positive after they are applied
    verify_hash

    # we only do these steps when there is a nxt block
    unless @nxt.nil?
      verify_id
      verify_prev_hash
      verify_timestamp

      @nxt.verify_block(wallets)
    end

    wallets
  end

  # @block_hash is what it is expected to be
  def verify_hash
    transactions = @transaction_list.join(":")
    time = "#{@seconds}.#{@nanoseconds}"
    line = [@id, @prev_hash.to_s(16), transactions, time].join("|")
    expected = calculate_hash(line)
    err(@id, "Calculated hash #{expected} did not match given hash #{@block_hash}") unless expected == @block_hash
  end

  # @nxt.id = @id + 1
  def verify_id
    expected = @id + 1
    actual = @nxt.id
    err(expected, "ID should be #{expected}, was #{actual}.") unless expected == actual
  end

  # @nxt.prev_hash == @block_hash
  def verify_prev_hash
    err(@id + 1, "prev_hash did not match previous block's hash") unless @nxt.prev_hash == @block_hash
  end

  # @next.time > @time
  def verify_timestamp
    g_seconds = @nxt.seconds > @seconds
    g_nanoseconds = @nxt.nanoseconds > @nanoseconds
    chronological = (g_seconds) || (@nxt.seconds == @seconds && g_nanoseconds)
    err(@id + 1, "Timestamps out of order") unless chronological
  end

  def verify_transaction_list(wallets)
    # work
  end

  def verify_nobody_has_negative_balance(wallets)
    # work
  end
end

def err(line, message)
  raise ArgumentError.new("Line #{line}: #{message}")
end
