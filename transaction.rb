class Transaction

  attr_reader :from_name, :to_name, :amt

  def initialize(from_name, to_name, amt)
    @from_name = from_name
    @to_name = to_name
    @amt = amt
  end
end
