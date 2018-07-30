class Transaction
  attr_reader :from_name, :to_name, :amt

  def initialize(from_name, to_name, amt)
    @from_name = from_name
    @to_name = to_name
    @amt = amt

    @system = from_name == "SYSTEM"
  end

  def system?
    @system
  end

  def to_s
    "#{@from_name}>#{@to_name}(#{@amt})"
  end
end
