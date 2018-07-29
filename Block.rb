class Block
  attr_accessor: :id, :prev_hash, :transaction_list, :timestamp_seconds, :timestamp_nano, :my_hash

  def initialize(id, prev_hash, transaction_list, timestamp_seconds, timestamp_nano, my_hash)
    @id = id
    @prev_hash = prev_hash
    @transaction_list = transaction_list
    @timestamp_seconds = timestamp_seconds
    @timestamp_nano = timestamp_nano
    @my_hash = my_hash
  end

  def verify_id(id)
    # work
  end

  def verify_prev_hash(prev_hash)
    # work
  end

  # Multiple chances for issues, might need to be split up to check for everything that could go wrong.
  def verify_transaction_list(transaction_list)
    # work
  end

  def verify_nobody_has_negative_balance(transaction_list)
    # work
  end

  def verify_addresses_are_all_valid(transaction_list)
    # work
  end

  def verify_timestamp_seconds(timestamp_seconds)
    # work
  end

  def verify_timestamp_nano(timestamp_nano)
    # work
  end

  def verify_my_hash(my_hash)
    # work
  end

  def verify_all
    # Call all verifications
  end

end
