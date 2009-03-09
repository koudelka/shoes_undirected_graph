class Vertex
  attr_accessor :head
  attr_accessor :tail
  attr_accessor :line


  def initialize(slot, head, tail)
    self.head = head
    self.tail = tail

    self.line = slot.line
    update_line_position
  end

  def update_line_position
    return if head.nil? or tail.nil?

    line.move(head.left + head.height/2, head.top + head.width/2)
    line.width = tail.left + tail.width/2 - line.left
    line.height = tail.top + tail.height/2 - line.top
  end

  def to_s
    "#{head} -> #{tail}"
  end
end
