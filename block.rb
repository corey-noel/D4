require_relative 'hashing.rb'
require_relative 'verifying.rb'

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

  # recursively verify the block_chain
  # treats this block as the head
  # called externally only
  def verify_block_chain
    verify_first_id
    verify_first_prev_hash
    verify_first_transaction_list
    verify_block({})
  end

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

  # accepts a dictionary of wallets
  # applies @transaction_list to wallets dictionary
  # verifies source exists
  # currently the slowest method in program
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
    wallets
  end
end
