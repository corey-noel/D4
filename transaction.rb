# Transaction class
# represents an individual transaction between two users
class Transaction
  attr_reader :src, :dest, :amt

  def initialize(src, dest, amt)
    @src = src
    @dest = dest
    @amt = amt

    @system = src == 'SYSTEM'
  end

  def system?
    @system
  end

  def to_s
    "#{@src}>#{@dest}(#{@amt})"
  end
end
