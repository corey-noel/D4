require_relative 'parsing.rb'

if ARGV.length != 1
  puts 'Usage: ruby verifier.rb [filename]'
  exit(-1)
end

begin
  head = read_block_chain(ARGV[0])

  exit(-1) if head.nil?

  wallet = head.verify_block_chain
  wallet.each { |address, amt| puts "#{address}: #{amt}" }
rescue ArgumentError => e
  puts e.message
rescue Errno::ENOENT
  puts "File #{ARGV[0]} does not exist"
end
