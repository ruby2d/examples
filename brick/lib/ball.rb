# Deals with the logic of the brick's ball.
# @author Miłosz Osiński <milosz@icoded.com>
class Ball < Square
  DEFAULTS = {
    speed: 3,
    direction: { x: 1, y: 1 }
  }.freeze

  attr_accessor :speed, :direction, :scored, :scored_at, :failed_at

  # @api public
  # @param speed [Integer, Float, nil] ball's speed
  # @param direction [Hash, nil] ball's x and y axis directions
  # @return [Ball]
  def initialize(speed: nil, direction: nil, **args)
    super(args)
    @speed = speed || DEFAULTS[:speed]
    @direction = direction || DEFAULTS[:direction]
  end

  # @api public
  # @param window [Window] the game's window
  # @param pad [Pad] the game's pad
  # @param bricks [Array] the game's bricks
  # @return [Hash] ball's current position
  def move(window:, pad:, bricks:)
    self.scored_at = nil

    if edge_collision?(:x, window)
      self.direction[:x] *= -1
    elsif edge_collision?(:y, window)
      self.failed_at = Time.now if check_edge_collision(:y, window) == :bottom
      self.direction[:y] *= -1
    elsif pad_collision?(pad)
      self.direction[:y] *= -1
    elsif brick_collision?(bricks).any?
      self.scored_at = Time.now
      self.scored = brick_collision?(bricks)
      self.direction[:y] *= -1
    end

    self.x += direction[:x] * speed
    self.y += direction[:y] * speed

    { x: x, y: y }
  end

  # @api public
  # @return [Boolean] did it score a new point?
  def scored?
    !scored_at.nil?
  end

  # @api public
  # @return [Boolean] did it fail?
  def failed?
    !failed_at.nil?
  end

  # @api public
  # @param window [Window] the game's window
  # @param pad [Pad] the game's pad
  # @return [Integer, Float]
  def reset_position!(window, pad)
    self.x = pad.x + pad.width / 2 - 5
    self.y = 450
  end

  private

  # @api private
  # @param axis [Symbol] which axis to check the collision
  # @param window [Window] the game's window
  # @return [Boolean]
  def edge_collision?(axis, window)
    !check_edge_collision(axis, window).nil?
  end

  # @api private
  # @param axis [Symbol] which axis to check the collision
  # @param window [Window] the game's window
  # @return [Symbol] edge side where ball has collided
  def check_edge_collision(axis, window)
    if axis == :x && x + width >= window.get(:width)
      :right
    elsif axis == :x && x <= 0
      :left
    elsif axis == :y && y + height >= window.get(:height)
      :bottom
    elsif axis == :y && y <= 0
      :top
    end
  end

  # @api private
  # @param pad [Pad] the game's pad
  # @return [Boolean] has the ball collided with the pad?
  def pad_collision?(pad)
    y <= pad.y + pad.height && y + height >= pad.y &&
      [x + width, pad.x + pad.width].min - [x, pad.x].max > 0
  end

  # @api private
  # @param bricks [Hash] the game's bricks
  # @return [Boolean] has the ball collided with any of the bricks?
  def brick_collision?(bricks)
    bricks.select do |brick|
      y <= brick.y + brick.height && y + height >= brick.y &&
        [x + width, brick.x + brick.width].min - [x, brick.x].max > 0
    end
  end
end
