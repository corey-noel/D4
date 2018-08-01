require_relative '../hashing.rb'
require 'minitest/autorun'

class BlockTest < MiniTest::Test

  def setup
    @first = Block.new(0, 0, nil, 1518892051, 737141000, Integer("1c12", 16))
    @second = Block.new(1, Integer("1c12", 16), nil, 1518892051, 740967000, Integer("abb2", 16))
    @third = Block.new(2, Integer("abb2", 16), nil, 1518892051, 753197000, Integer("c72d", 16))
  end
end
