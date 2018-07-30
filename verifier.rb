require_relative 'parsing.rb'

begin
  head = read_block_chain(ARGV[0])
rescue ArgumentError => e
  puts e.message
end

exit(-1) if head.nil?

begin
  wallet = head.verify_block_chain
  wallet.each{ |address, amt| puts "#{address}: #{amt}"}
rescue ArgumentError => e
  puts e.message
end
