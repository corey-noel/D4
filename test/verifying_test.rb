require_relative '../verifying.rb'
require_relative '../block.rb'
require_relative '../transaction.rb'

class VerifyingTest < MiniTest::Test
  def setup
    @t1_1 = Transaction.new("Wu", "Edward", 16)
    @t1_2 = Transaction.new("SYSTEM", "Amina", 100)
    t1s = [@t1_1, @t1_2]

    @t2_1 = Transaction.new("Louis", "Louis", 1)
    @t2_2 = Transaction.new("George", "Edward", 15)
    @t2_3 = Transaction.new("Sheba", "Wu", 1)
    @t2_4 = Transaction.new("Henry", "James", 12)
    @t2_5 = Transaction.new("Amina", "Pakal", 22)
    @t2_6 = Transaction.new("SYSTEM", "Kublai", 100)
    t2s = [@t2_1, @t2_2, @t2_3, @t2_4, @t2_5, @t2_6]

    @b1 = Block.new(6, Integer("d072", 16), t1s, 1518892051, 793695000, Integer("949", 16))
    @b2 = Block.new(7, Integer("949", 16), t2s, 1518892051, 799497000, Integer("32aa", 16))
    @b1.nxt = @b2
  end

  def test_verify_hash_correct
    @b1.verify_hash
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_hash_incorrect
    b = Block.new(1, Integer("abcd", 16), [@t1_1], 1000000, 200000, Integer("8008135", 16))
    assert_raises(ArgumentError) do
      b.verify_hash
    end
  end

  def test_verify_id_correct
    @b1.verify_id
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_id_incorrect
    b_1 = Block.new(10, 0, [], 1000, 500, 0)
    b_2 = Block.new(13, 0, [], 1000, 500, 0)
    b_1.nxt = b_2
    assert_raises(ArgumentError) do
      b_1.verify_id
    end
  end

  def test_verify_prev_hash_correct
    @b1.verify_prev_hash
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_prev_hash_incorrect
    @b1.nxt = Block.new(7, 234234, [], 10, 5, 0)
    assert_raises(ArgumentError) do
      @b1.verify_prev_hash
    end
  end

  def test_verify_transactions_correct
    @b1.verify_transaction_list
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_transactions_empty
    b = Block.new(2, 0, [], 100, 200, 123)
    assert_raises(ArgumentError) do
      b.verify_transaction_list
    end
  end

  def test_verify_transactions_no_system
    b = Block.new(2, 0, [@t1_1], 100, 200, 123)
    assert_raises(ArgumentError) do
      b.verify_transaction_list
    end
  end

  def test_verify_positive_balances_all_positive
    wallets = {"Alice" => 10, "Bob" => 20, "George" => 40}
    @b1.verify_positive_balances(wallets)
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_positive_balances_one_negative
    wallets = {"Alice" => 10, "Bob" => 15}
    wallets.default = 0
    t = Transaction.new("Alice", "Bob", 15)
    b = Block.new(0, 0, [t], 100, 200, 123)
    assert_raises(ArgumentError) do
      b.apply_transactions(wallets)
      b.verify_positive_balances(wallets)
    end
  end

  def test_verify_positive_balances_zeros
    wallets = {"Alice" => 10, "Bob" => 15}
    wallets.default = 0
    t = Transaction.new("Alice", "Bob", 10)
    b = Block.new(0, 0, [t], 100, 200, 123)
    b.apply_transactions(wallets)
    b.verify_positive_balances(wallets)
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_first_id_correct
    b = Block.new(0, 0, [], 100, 200, 0)
    b.verify_first_id
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_first_id_incorrect
    b = Block.new(1, 0, [], 100, 200, 0)
    assert_raises(ArgumentError) do
      b.verify_first_id
    end
  end

  def test_verify_first_prev_hash_correct
    b = Block.new(0, 0, [], 100, 200, 0)
    b.verify_first_prev_hash
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_first_prev_hash_incorrect
    b = Block.new(0, 1231, [], 100, 200, 0)
    assert_raises(ArgumentError) do
      b.verify_first_prev_hash
    end
  end

  def test_verify_first_transaction_list_correct
    b1 = Block.new(0, 0, [@t1_1], 100, 200, 0)
    b1.verify_first_transaction_list
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_verify_first_transaction_list_incorrect
    b1 = Block.new(0, 0, [@t1_1, @t1_2], 100, 200, 0)
    assert_raises(ArgumentError) do
      b1.verify_first_transaction_list
    end
  end

  def test_timestamp_s_less_n_less
    b1, b2 = helper_timestamp_blocks(100, 10, 50, 5)
    assert_raises(ArgumentError) do
      b1.verify_timestamp
    end
  end

  def test_timestamp_s_less_n_equal
    b1, b2 = helper_timestamp_blocks(100, 10, 50, 50)
    assert_raises(ArgumentError) do
      b1.verify_timestamp
    end
  end

  def test_timestamp_s_less_n_greater
    b1, b2 = helper_timestamp_blocks(100, 10, 5, 50)
    assert_raises(ArgumentError) do
      b1.verify_timestamp
    end
  end

  def test_timestamp_s_equal_n_less
    b1, b2 = helper_timestamp_blocks(100, 100, 50, 5)
    assert_raises(ArgumentError) do
      b1.verify_timestamp
    end
  end

  def test_timestamp_s_equal_n_equal
    b1, b2 = helper_timestamp_blocks(100, 100, 50, 50)
    assert_raises(ArgumentError) do
      b1.verify_timestamp
    end
  end

  def test_timestmap_s_equal_n_greater
    b1, b2 = helper_timestamp_blocks(100, 100, 5, 50)
    b1.verify_timestamp
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_timestamp_s_greater_n_less
    b1, b2 = helper_timestamp_blocks(10, 100, 50, 5)
    b1.verify_timestamp
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_timestamp_s_greater_n_equal
    b1, b2 = helper_timestamp_blocks(10, 100, 50, 50)
    b1.verify_timestamp
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end

  def test_timestamp_s_greater_n_greater
    b1, b2 = helper_timestamp_blocks(10, 100, 5, 50)
    b1.verify_timestamp
    assert true
  rescue ArgumentError => e
    assert false, e.message
  end
end

def helper_timestamp_blocks(b1_sec, b2_sec, b1_nano, b2_nano)
  b1 = Block.new(0, 0, [], b1_sec, b1_nano, 100)
  b2 = Block.new(1, 100, [], b2_sec, b2_nano, 200)
  b1.nxt = b2
  return b1, b2
end
