require_relative '../hashing.rb'

class HashingTest < MiniTest::Test

  def test_char_lookup
    assert_equal 5667, hash_lookup(9)
  end

  def test_char_calculate
    assert_equal 5667, hash_char_val(9) % 65536
  end

  def test_calculate_hash_default
    assert_equal 17017, calculate_hash("hello")
  end

  def test_calculate_hash_lookup
    assert_equal 17017, calculate_hash("hello", :hash_lookup)
  end

  def test_calculate_hash_calculate
    assert_equal 17017, calculate_hash("hello", :hash_char_val)
  end
end
