require 'ruby2d'

require './lib/ball'
require './lib/paddle'
require './lib/match'

##
# Window & FPS
##

set title: 'AlleyWay',
    background: 'black',
    with: 640,
    height: 480,
    resizable: false

fps_display = Text.new(get(:fps).to_i, x: 315, y: 463, size: 12)

##
# Pad
##

pad = Paddle.new(
  x: get(:width) / 2 - 60 / 2,
  y: get(:height) - 15,
  width: 60,
  height: 10,
  speed: 7,
  constraints: { x: { min: 0, max: get(:width) - 50 } }
)

##
# Bricks
##

bricks = []

4.times do |row|
  10.times do |column|
    bricks << Paddle.new(
      x: get(:width) / 10 * column,
      y: 15 * row,
      width: 60,
      height: 10,
      speed: 0,
      constraints: {}
    )
  end
end

##
# Ball
##

ball = Ball.new(
  x: pad.x + (pad.width / 2) - 5,
  y: 450,
  size: 10,
  speed: 5
)

##
# Pause
##

pause_display = Text.new(
  'PRESS SPACE',
  x: get(:width) / 2 - 110,
  y: get(:height) / 2 - 20,
  font: 'assets/PressStart2P.ttf',
  color: 'gray',
  size: 20,
  opacity: 1
)

##
# Main
##

match = Match.new

# Paddle movement
on :key_held do |event|
  pad.move(event, left: 'a', right: 'd')

  if match.paused?
    ball.x = pad.x + (pad.width / 2) - (ball.width / 2)
  end
end

# Game pause
on :key_down do |event|
  if event.key == 'space'
    match.paused = false
    pause_display.opacity = -1
  end
end

update do
  fps_display.text = get(:fps).to_i

  if match.paused?
    next
  else
    ball.move(window: get(:window), pad: pad, bricks: bricks)

    if ball.scored?
      ball.scored.each do |brick|
        index = bricks.index(brick)
        bricks[index].width = 0
        bricks.delete(brick)
      end
    elsif ball.failed?
      match.paused = !match.paused
      pause_display.opacity = 1
      match.restart!(get(:window), ball, pad)
    end
  end
end

show
