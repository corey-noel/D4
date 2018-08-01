require_relative '../parsing.rb'

class ParsingTest < MiniTest::Test

  # tests that the length of the array returned by
  # split_block is correct
  def test_split_block_val
    in_str = "0|abcd|you>me(100)|100.200|sdfg"
    assert_equal 5, split_block(in_str).length
  end

  # tests the contents of the array returned by split_block
  def test_split_block_length
    in_str = "0|abcd|you>me(100)|100.200|sdfg"
    out_arr = ["0", "abcd", "you>me(100)", "100.200", "sdfg"]
    assert_equal out_arr, split_block(in_str)
  end

  # tests that split_block raises an error when the input is too long
  def test_split_block_too_long
    in_str = "0|abcd|you>me(100)|100.200|sdfg|???"
    assert_raises(ArgumentError) { split_block(in_str) }
  end

  # tests that split_block raises an error when the input is too short
  def test_split_block_too_short
    in_str = "0|you>me(100)|100.20|sdfg"
    assert_raises(ArgumentError) { split_block(in_str) }
  end

  # tests that parse_id returns a successful parse correctly
  def test_parse_id_valid
    assert_equal 19, parse_id("19")
  end

  # tests that parse_id raises an error when it can't parse
  def test_parse_id_invalid
    assert_raises(ArgumentError) { parse_id("bad") }
  end

  # tests that parse_hash returns a valid hash correctly
  def test_parse_hash_valid
    assert_equal 100000, parse_hash("186A0")
  end

  # tests that parse_hash will raise an error when it can't parse
  def test_parse_hash_invalid
    assert_raises(ArgumentError) { parse_hash("not_hex") }
  end

  def test_parse_transaction_list_valid
    in_str = "you>me(100):me>you(2):bob>george(19)"
    assert_equal 3, parse_transaction_list(in_str).length
  end

  def test_parse_transaction_list_invalid_syntax
    in_str = "you>me(100):me>you(2)::bob>george(19)"
    assert_raises(ArgumentError) { parse_transaction_list(in_str) }
  end

  def test_parse_transaction_src
    in_str = "you>me(200)"
    assert_equal "you", parse_transaction(in_str).src
  end

  def test_parse_transaction_dest
    in_str = "you>me(200)"
    assert_equal "me", parse_transaction(in_str).dest
  end

  def test_parse_transaction_amt
    in_str = "you>me(200)"
    assert_equal 200, parse_transaction(in_str).amt
  end

  def test_parse_transaction_invalid_syntax
    in_str = "you?me(4000)"
    assert_raises(ArgumentError) { parse_transaction(in_str) }
  end

  def test_parse_timestamp_seconds
    in_str = "12345.6789"
    seconds, _ = parse_time_stamp(in_str)
    assert_equal 12345, seconds
  end

  def test_parse_timestamp_nanoseconds
    in_str = "12345.6789"
    _, nanoseconds = parse_time_stamp(in_str)
    assert_equal 6789, nanoseconds
  end

  def test_parse_timestamp_too_long
    in_str = "123.456.678"
    assert_raises(ArgumentError) { parse_time_stamp(in_str) }
  end

  def test_parse_timestamp_not_int
    in_str = "1b23.4567"
    assert_raises(ArgumentError) { parse_time_stamp(in_str) }
  end

  def test_parse_block
    in_arr = ["10", "abcd", "you>me(100)", "100.200", "1234"]
    assert_instance_of(Block, parse_block(in_arr))
  end

  def test_parse_block_wrong_length
    in_arr = ["10", "abcd", "you>me(100)", "100.200"]
    assert_raises(ArgumentError) { parse_block(in_arr) }
  end

  def test_parse_block_invalid
    in_arr = ["10", "abcd", "?????", "100.200", "1234"]
    assert_raises(ArgumentError) { parse_block(in_arr) }
  end

  def test_read_block_chain_valid
    filename = "test_files/sample.txt"
    assert_instance_of(Block, read_block_chain(filename))
  end

  def test_read_block_chain_invalid
    filename = "test_files/bad_transaction_syntax.txt"
    assert_raises(ArgumentError) { read_block_chain(filename) }
  end
end
