require 'flamegraph'

Flamegraph.generate('flamegrapher.html') do
  require_relative 'verifier.rb'
end
