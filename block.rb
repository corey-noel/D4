require_relative 'hashing.rb'

# Block class
# represents a single block in our chain
# functions as a linked list node
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
    verify_block({})
  end

  # @id of first block = 0
  def verify_first_id
    block_err(0, "Invalid block number #{@id}, should be 0") unless @id.zero?
  end

  # @prev_hash of first block = 0
  def verify_first_prev_hash
    block_err(0, "Invalid previous hash #{@prev_hash.to_s(16)}, should be 0") unless @prev_hash.zero?
  end

  # first block transaction list
  # should have only one transaction
  def verify_first_transaction_list
    return if @transaction_list.length == 1
    block_err(0, "Invalid transaction length #{@transaction_list.length}, should be 1")
  end

  ##### ALL BLOCK VERIFICATIONS #####
  # recursively verify the block_chain
  # wallets is a dictionary of amounts of billcoin each individual has
  # called internally only
  def verify_block(wallets)
    # we always do these steps
    apply_transactions wallets
    verify_transaction_list
    verify_positive_balances wallets
    verify_hash

    # we only do these steps when there is a nxt block
    unless @nxt.nil?
      verify_id
      verify_prev_hash
      verify_timestamp

      @nxt.verify_block wallets
    end

    wallets
  end

  # @block_hash matches calculated hash
  def verify_hash
    transactions = @transaction_list.join(':')
    time = "#{@seconds}.#{@nanoseconds}"
    line = [@id, @prev_hash.to_s(16), transactions, time].join('|')
    expected = calculate_hash(line)
    return if expected == @block_hash
    block_err(@id, "Invalid hash #{@block_hash.to_s(16)} for #{line}, should be #{expected.to_s(16)}")
  end

  # @nxt.id = @id + 1
  def verify_id
    expected = @id + 1
    actual = @nxt.id
    block_err(expected, "Invalid block number #{actual}, should be #{expected}") unless expected == actual
  end

  # @nxt.prev_hash == @block_hash
  def verify_prev_hash
    return if @nxt.prev_hash == @block_hash
    block_err(@id + 1, "Invalid previous hash #{@nxt.prev_hash.to_s(16)}, should be #{@block_hash.to_s(16)}")
  end

  # @next.time > @time
  def verify_timestamp
    return if @nxt.seconds > @seconds || (@nxt.seconds == @seconds && @nxt.nanoseconds > @nanoseconds)
    prev_ts = "#{@seconds}.#{@nanoseconds}"
    new_ts = "#{@nxt.seconds}.#{@nxt.nanoseconds}"
    block_err(@id + 1, "Invalid previous timestamp #{prev_ts} >= new timestamp #{new_ts}")
  end

  # transaction list length >= 1
  # last transaction is from system
  def verify_transaction_list
    block_err(@id, 'Transaction list length should be at least 1') unless @transaction_list.length >= 1
    return if @transaction_list[-1].system?
    block_err(@id, "Invalid transaction src #{@transaction_list[-1].src}, final transaction should be from SYSTEM")
  end

  # all wallets have positive balances at end of block
  def verify_positive_balances(wallets)
    wallets.each do |address, amt|
      block_err(@id, "Invalid block, address #{address} has #{amt} billcoins") unless amt >= 0
    end
  end

  # accepts a dictionary of wallets
  # applies @transaction_list to wallets dictionary
  # verifies source exists
  def apply_transactions(wallets)
    @transaction_list.each do |transaction|
      source_exists = transaction.system? || wallets.include?(transaction.src)
      block_err(id, "Invalid transaction #{transaction}, source #{transaction.src} does not exist") unless source_exists
      if wallets.include?(transaction.dest)
        wallets[transaction.dest] += transaction.amt
      else
        wallets[transaction.dest] = transaction.amt
      end

      wallets[transaction.src] -= transaction.amt if wallets.include? transaction.src
    end
  end
end

# error raising helper method
def block_err(line, message)
  raise ArgumentError, "Line #{line}: #{message}"
end
