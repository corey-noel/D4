require_relative 'parsing.rb'

head = read_block_chain(ARGV[0])
exit(-1) if head.nil?

begin
  puts head.verify_block_chain
rescue ArgumentError => e
  puts e.message
end
