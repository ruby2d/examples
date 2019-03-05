require 'ruby2d'
require_relative 'union'

light_is_on = true

set background: 'aqua'
set title: "Simple Switch"

middle_bar = Square.new(
    x:295, y:215,
    size:50,
    color: 'green',
    z:0
)

left_circle = Circle.new(
    x: 300, y: 240,
    radius: 25,
    sectors: 32,
    color: 'white',
    z: 1
)

right_circle = Circle.new(
    x: 340, y: 240,
    radius: 25,
    sectors: 32,
    color: 'green',
    z: 0
)

# Create a union of all shapes that are a part of the switch
switch = Union.new([left_circle,middle_bar,right_circle])

on :mouse_down do |event|
  # If clicked while on top of the switch
  if switch.contains?(event.x, event.y)
    if light_is_on # same as 'if light_is_on == true'

      light_is_on = false
      set background: 'blue'

      left_circle.z = 0
      right_circle.z = 1

      middle_bar.color = 'silver'
      left_circle.color = 'silver'
      right_circle.color = 'white'

    else

      light_is_on = true
      set background: 'aqua'

      left_circle.z = 1
      right_circle.z = 0

      middle_bar.color = 'green'
      left_circle.color = 'white'
      right_circle.color = 'green'

    end
  end
end

show
