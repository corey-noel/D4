require 'simplecov'
SimpleCov.coverage_dir('data/coverage')
SimpleCov.start do
  add_filter "/test/"
  add_filter "/scripts/"
end

require 'minitest/autorun'
require_relative 'parsing_test.rb'
require_relative 'transaction_test.rb'
require_relative 'hashing_test.rb'
require_relative 'block_test.rb'
require_relative 'verifying_test.rb'
