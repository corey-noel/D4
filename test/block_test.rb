require_relative '../hashing.rb'

class BlockTest < MiniTest::Test

  def setup
    t1_1 = Transaction.new("SYSTEM", "Henry", 100)
    t2_1 = Transaction.new("SYSTEM", "George", 100)
    t3_1 = Transaction.new("George", "Amina", 16)
    t3_2 = Transaction.new("Henry", "James", 4)
    t3_3 = Transaction.new("Henry", "Cyrus", 17)
    t3_4 = Transaction.new("Henry", "Kublai", 4)
    t3_5 = Transaction.new("George", "Rana", 1)
    t3_6 = Transaction.new("SYSTEM", "Wu", 100)

    @first = Block.new(0, 0, [t1_1], 1518892051, 737141000, Integer("1c12", 16))
    @second = Block.new(1, Integer("1c12", 16), [t2_1], 1518892051, 740967000, Integer("abb2", 16))
    @third = Block.new(2, Integer("abb2", 16), [t3_1, t3_2, t3_3, t3_4, t3_5, t3_6], 1518892051, 753197000, Integer("c72d", 16))

    @first.nxt = @second
    @second.nxt = @third
  end

  def test_apply_transactions
    wallets = {"Henry" => 100}
    wallets.default = 0
    expected = {"Henry" => 100, "George" => 100}
    assert_equal expected, @second.apply_transactions(wallets)
  end

  def test_verify_block_chain
    expected = {"Henry"=>75, "George"=>83, "Amina"=>16, "James"=>4, "Cyrus"=>17, "Kublai"=>4, "Rana"=>1, "Wu"=>100}
    assert_equal expected, @first.verify_block_chain
  end

  def test_verify_block
    wallets = {"Henry"=>100, "George"=>100}
    wallets.default = 0
    expected = {"Henry"=>75, "George"=>83, "Amina"=>16, "James"=>4, "Cyrus"=>17, "Kublai"=>4, "Rana"=>1, "Wu"=>100}
    assert_equal expected, @third.verify_block(wallets)
  end
end
