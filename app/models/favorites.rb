class Favorites

  attr_reader :contents

  def initialize(initial_contents = Hash.new(0))
    @contents = initial_contents
  end

  def total_count
    @contents.values.sum
  end

end
