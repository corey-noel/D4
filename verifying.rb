# error raising helper method
def verify_error(line, message)
raise ArgumentError, "Line #{line}: #{message}"
end

class Block
  ##### ALL BLOCK VERIFICATIONS #####
  # @block_hash matches calculated hash
  def verify_hash
    transactions = @transaction_list.join(':')
    time = "#{@seconds}.#{@nanoseconds}"
    line = [@id, @prev_hash.to_s(16), transactions, time].join('|')
    expected = calculate_hash(line)
    return if expected == @block_hash
    verify_error(@id, "Invalid hash #{@block_hash.to_s(16)} for #{line}, should be #{expected.to_s(16)}")
  end

  # @nxt.id = @id + 1
  def verify_id
    expected = @id + 1
    actual = @nxt.id
    verify_error(expected, "Invalid block number #{actual}, should be #{expected}") unless expected == actual
  end

  # @nxt.prev_hash == @block_hash
  def verify_prev_hash
    return if @nxt.prev_hash == @block_hash
    verify_error(@id + 1, "Invalid previous hash #{@nxt.prev_hash.to_s(16)}, should be #{@block_hash.to_s(16)}")
  end

  # @next.time > @time
  def verify_timestamp
    return if @nxt.seconds > @seconds || (@nxt.seconds == @seconds && @nxt.nanoseconds > @nanoseconds)
    prev_ts = "#{@seconds}.#{@nanoseconds}"
    new_ts = "#{@nxt.seconds}.#{@nxt.nanoseconds}"
    verify_error(@id + 1, "Invalid previous timestamp #{prev_ts} >= new timestamp #{new_ts}")
  end

  # transaction list length >= 1
  # last transaction is from system
  def verify_transaction_list
    verify_error(@id, 'Transaction list length should be at least 1') unless @transaction_list.length >= 1
    return if @transaction_list[-1].system?
    verify_error(@id, "Invalid transaction src #{@transaction_list[-1].src}, final transaction should be from SYSTEM")
  end

  # all wallets have positive balances at end of block
  def verify_positive_balances(wallets)
    wallets.each do |address, amt|
      verify_error(@id, "Invalid block, address #{address} has #{amt} billcoins") unless amt >= 0
    end
  end

  ##### FIRST BLOCK VERIFICATIONS #####
  # @id of first block = 0
  def verify_first_id
    verify_error(0, "Invalid block number #{@id}, should be 0") unless @id.zero?
  end

  # @prev_hash of first block = 0
  def verify_first_prev_hash
    verify_error(0, "Invalid previous hash #{@prev_hash.to_s(16)}, should be 0") unless @prev_hash.zero?
  end

  # first block transaction list
  # should have only one transaction
  def verify_first_transaction_list
    return if @transaction_list.length == 1
    verify_error(0, "Invalid transaction length #{@transaction_list.length}, should be 1")
  end
end
