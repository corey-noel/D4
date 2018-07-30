require_relative 'parsing.rb'

begin
  head = read_block_chain(ARGV[0])
rescue ArgumentError => e
  puts e.message
end

exit(-1) if head.nil?

begin
  puts head.verify_block_chain
rescue ArgumentError => e
  puts e.message
end
