require 'simplecov'
SimpleCov.coverage_dir('data/coverage')
SimpleCov.start

require 'minitest/autorun'
require_relative 'parsing_test.rb'
require_relative 'transaction_test.rb'
require_relative 'hashing_test.rb'
