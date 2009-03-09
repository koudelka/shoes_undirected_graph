class Node
  attr_accessor :parents
  attr_accessor :children
  attr_accessor :vertexes
  attr_accessor :name
  attr_accessor :shape

  attr_writer :selected

  attr_accessor :selected_indicators
  BOX_SIDE = 4
  BOX_DISTANCE = 2

  def initialize(slot)
    self.vertexes = []
    selected = false

    self.selected_indicators = {
      :top_left     => slot.rect(0, 0, BOX_SIDE, BOX_SIDE),
      :top_right    => slot.rect(0, 0, BOX_SIDE, BOX_SIDE),
      :bottom_left  => slot.rect(0, 0, BOX_SIDE, BOX_SIDE),
      :bottom_right => slot.rect(0, 0, BOX_SIDE, BOX_SIDE),
    }
    deselect
    move
  end

  def move(delta=Point.new(0, 0))
    new_pos = Point.new(shape.left + delta.x, shape.top + delta.y)
    selected_indicators[:top_left].move(new_pos.x-BOX_SIDE-BOX_DISTANCE, new_pos.y-BOX_SIDE-BOX_DISTANCE)
    selected_indicators[:top_right].move(new_pos.x+shape.width+BOX_DISTANCE, new_pos.y-BOX_SIDE-BOX_DISTANCE)
    selected_indicators[:bottom_left].move(new_pos.x+shape.width+BOX_DISTANCE, new_pos.y+shape.height+BOX_DISTANCE)
    selected_indicators[:bottom_right].move(new_pos.x-BOX_SIDE-BOX_DISTANCE, new_pos.y+shape.height+BOX_DISTANCE)
    shape.move(new_pos.x, new_pos.y)
  end

  def select
    selected_indicators.values.each do |box|
      box.show
    end
  end

  def deselect
    selected_indicators.values.each do |box|
      box.hide
    end
  end

  def method_missing(method, *args)
    shape.send(method, *args)
  end
end
