require 'ruby2d'

set title: "Color Dodge Game"
set background: "black"


class Enemy
  attr_reader :collision, :body
  attr_accessor :collision_opacity, :body_color
  attr_accessor :x, :y, :size

  def initialize(opts = {})

    puts opts

    @x = opts[:x]
    @y = opts[:y]
    @size = opts[:size]
    @body_color = opts[:color]

    
    @body = Square.new( x: @x, y: @y, size: @size, color: @body_color )

  end

  def body_color=(color)
    @body.color = color
  end

  def moveLeft(quantity)
    @body.x -= quantity
  end

  def getBodyPosition
    return @body.x, @body.y
  end

  def size
    return @body.size
  end

  def radius
    return @body.size*Math.sqrt(2)/2
  end
end


# Instantiating the player
player = Circle.new(x: 10, y: 50, radius: 10, color: 'yellow')

player_life = 300

# Instantiating the score text and variable
score = 0
score_text = Text.new(x: (get :width)-150, y: 10, text: "Score: #{score}", font: "../fonts/Ubuntu.ttf", color: 'white')

# Creating a lifebar
lifebar = Rectangle.new(x: 10, y: 10, z: 1, width: player_life, height: 25, color: 'red')


# Instantiating the enemies array and a tick counter
enemies = []

tick = 0

# Event of pressing a key on the keyboard
on :key do |e|
  if e.type == :held
    # Here we check the bounds of the screen so the player can't trespass them.
    case e.key
      when 's'
        player.y += player.radius/2 if player.y < (get :height)-player.radius
      when 'w'
        player.y -= player.radius/2 if player.y > 0
      when 'a'
        player.x -= player.radius/2 if player.x > 0
      when 'd'
        player.x += player.radius/2 if player.x < (get :width)-player.radius
    end
  end
end

update do

  # Game over condition. Resets the game and the score instantly.
  if(lifebar.width == 0)
    enemies.each do |enemy|
      enemy.body_color = 'black'
    end
    enemies.clear()
    score = 0
    lifebar.width = player_life
  end


  if(tick%5==0 && enemies.size < 25)
    enemies << Enemy.new(x: 620, y: (rand*460).floor, size: 25, collision_opacity: 0.3, color: 'random') #Square.new( x: 620, y: (rand*460).floor, size: 25 )
  end

  if(tick%25 == 0)
    score += 1
    score_text.text = "Score: #{score}"
  end

  enemies.each do |enemy|
    # Check for collisions with the player
    dx = player.x - enemy.getBodyPosition().first
    dy = player.y - enemy.getBodyPosition().last

    # Euclidian distance between the two centers of the squares
    distance = Math.sqrt(dx * dx + dy * dy)

    # If this calculated distance is less than the two radius of the shapes summed, then they are overlapping.
    if( distance < player.radius + enemy.radius )
      #puts "COLLISION!"

      # Reduces player life
      lifebar.width -= 5
    end

    # "Throw the blocks at the player at speed 8"
    enemy.moveLeft(8)

    # Enemy arrives at the left part of the screen, we "erase it"
    if enemy.getBodyPosition().first < 0 - enemy.size()
      enemy.body_color = 'black'
      enemies.delete(enemy)
    end
  end

  tick += 1
end

show