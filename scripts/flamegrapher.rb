require 'flamegraph'

filename = 'data/flamegrapher.html'

Flamegraph.generate(filename) do
  require_relative '../verifier.rb'
end

puts "Flame graph generated at #{filename}"
