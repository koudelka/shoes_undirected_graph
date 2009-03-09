require File.dirname(__FILE__)+'/node'

class Bubble < Node
  def initialize(slot)
    @shape = slot.oval((0..500).rand, (0..500).rand, 50)
    shape.style({ :fill => slot.white })
    super(slot)
  end
end
