#!/usr/bin/env shoes

require 'lib/shoes_selection_box/lib/selection_box'
require 'lib/bubble'
require 'lib/vertex'


Shoes.app do
  $app = self
  Shoes.show_log

  def object_at(objects, point)
    objects.each do |obj|
      return obj if obj.contains_point?(point)
    end
    nil
  end

  background white
  making_selection_box = false
  dragging_objects = false
  selection_box = SelectionBox.new($app.slot, {:fill => gray(0.6, 0.5), :strokewidth => 1})

  objects = []
  selected_objects = []

  v = Vertex.new($app.slot, nil, nil)
  objects << Bubble.new($app.slot)
  objects << Bubble.new($app.slot)
  v.head = objects.first
  v.tail = objects.last
  v.update_line_position

  objects.first.vertexes << v
  objects.last.vertexes << v

  shapes_to_objects = {}
  objects.each do |obj|
    shapes_to_objects[obj.shape] = obj
  end

  click do |button, x, y|
    click_point = Point.new(x, y)

    clicked_obj = object_at(objects, click_point)
    if clicked_obj.nil?
      selected_objects.each do |obj|
        obj.deselect
      end
      selected_objects.delete_if { true }

      making_selection_box = true
      selection_box.start_at(click_point)
    else
      dragging_objects = true
      unless selected_objects.include?(clicked_obj)
        clicked_obj.select
        selected_objects << clicked_obj
      end
    end
  end

  motion_point = nil
  last_motion_point = nil
  motion do |x, y|
    last_motion_point = motion_point
    motion_point = Point.new(x, y)

    if dragging_objects
      delta = Point.new(motion_point.x - last_motion_point.x,
                        motion_point.y - last_motion_point.y)

      selected_objects.each do |obj|
        obj.move(delta)
      end

      vertexes = selected_objects.collect do |obj|
        obj.vertexes
      end.flatten.uniq

      vertexes.each do |v|
        v.update_line_position
      end
    end

    selection_box.dragged_to(motion_point) if making_selection_box
  end

  release do |button, x, y|
    release_point = Point.new(x, y)

    if dragging_objects
      dragging_objects = false
    end

    if making_selection_box
      making_selection_box = false
      selection_box.released_at(release_point).each do |shape|
        obj = shapes_to_objects[shape]
        next if obj.nil? # is a vertex
        selected_objects << obj unless selected_objects.include?(obj)
        obj.select
      end
    end
  end

end
