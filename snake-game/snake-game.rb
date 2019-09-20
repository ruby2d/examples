require 'ruby2d'

# size of one piece of the snake
SPART_SIZE = 10

set title: 'Snake Game', background: 'navy', fps_cap: 24

snakeHead  = Square.new({ x: Window.width / 2,
                          y: Window.height / 2,
                          size: SPART_SIZE,
                          color: 'green' })
snake = [snakeHead]

dir = {
  x: SPART_SIZE,
  y: 0
}

def newFood
  Circle.new({ x: rand(SPART_SIZE..Window.width - SPART_SIZE),
               y: rand(SPART_SIZE..Window.height - SPART_SIZE),
               radius: SPART_SIZE / 2,
               color: 'fuchsia' })
end

food             = newFood
score            = 0
gameover         = false
drawGameOverText = false  # to draw the text once

on :key do |e|
  if e.type == :down
    case e.key
    when 'right'
      dir = {x: SPART_SIZE, y: 0}
    when 'down'
      dir = {x: 0, y: SPART_SIZE}
    when 'left'
      dir = {x: -SPART_SIZE, y: 0}
    when 'up'
      dir = {x: 0, y: -SPART_SIZE}
    when 'escape'
      close
    end
  end
end

update do
  if gameover
    if drawGameOverText
      txt = Text.new('Game Over',
                    {x: Window.width / 2, y: Window.height / 2,
                     size: 40,
                     font: '../fonts/Ubuntu.ttf'})
      txt.x -= txt.size * 2.5
      txt.y -= txt.size
      drawGameOverText = false
    end
  else
    head = snake.shift
    # detect collision
    if head.contains?( food.x - food.radius, food.y + food.radius ) ||
       head.contains?( food.x - food.radius, food.y - food.radius ) ||
       head.contains?( food.x + food.radius, food.y - food.radius ) ||
       head.contains?( food.x + food.radius, food.y + food.radius )
          # snake grows
          newPart = Square.new({x: head.x, y: head.y,
                                  size: SPART_SIZE,
                                  color: 'green'})
          snake.push( newPart )
          # create food at random location
          Window.remove( food )
          food = newFood
    end
    prevX = head.x
    prevY = head.y
    snake.each do |part|
      part.x, prevX = prevX, part.x
      part.y, prevY = prevY, part.y
    end
    # move
    head.x += dir[:x]
    head.y += dir[:y]
    # if hit one edge goes to the oposite one
    head.x = head.x % Window.width
    head.y = head.y % Window.height
    # hit itself
    snake.each do |part|
      if head.contains?( part.x + 1, part.y + 1 ) ||
         head.contains?( part.x + 1, part.y + part.size - 1 ) ||
         head.contains?( part.x + part.size - 1, part.y + 1 ) ||
         head.contains?( part.x + part.size - 1, part.y + part.size - 1 )
          gameover = true
          drawGameOverText = true
          break
      end
    end
    snake.unshift( head )
  end
end

show
