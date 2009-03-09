class Box < Node
  def initialize
    shape = rect((0..500).rand,(0..500).rand,50,50)
  end
end
