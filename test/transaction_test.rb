require_relative '../transaction.rb'
require 'minitest/autorun'

class TransactionTest < MiniTest::Test

  def setup
    @t = Transaction.new("Alice", "Bob", 15)
  end

  def test_is_system
    t = Transaction.new("SYSTEM", "Bob", 100)
    assert t.system?
  end

  def test_is_not_system
    refute @t.system?
  end

  def test_to_string
    assert_equal "Alice>Bob(15)", @t.to_s
  end

  def test_src
    assert_equal @t.src, "Alice"
  end

  def test_dest
    assert_equal @t.dest, "Bob"
  end

  def test_amt
    assert_equal @t.amt, 15
  end

end
