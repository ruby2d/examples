# Deals with the logic of the brick's paddle.
# @author Miłosz Osiński <milosz@icoded.com>
class Paddle < Rectangle
  DEFAULTS = { speed: 3 }.freeze

  attr_accessor :speed, :constraints

  # @api public
  # @param speed [Integer, Float, nil] pad's current speed
  # @param constraints [Hash] pad's constraints (e.g. max "y")
  # @return [Pad]
  def initialize(speed: nil, constraints: {}, **args)
    super(args)
    @speed = speed || DEFAULTS[:speed]
    @constraints = constraints
  end

  # @api public
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param speed [Integer, Float, nil] pad's speed
  # @return [Integer, Float] pad's current y position
  def move(event, left:, right:)
    if move_left?(event, left)
      self.x -= speed
    elsif move_right?(event, right)
      self.x += speed
    end
  end

  private

  # @api private
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param up [String] expected keyboard key for the up movement
  # @return [Boolean] is it allowed to move up?
  def move_left?(event, left)
    min_x = constraints.dig(:x, :min)
    event.key == left && (!min_x || x - speed >= min_x)
  end

  # @api private
  # @param event [Ruby2D::Window::KeyEvent] event captured from keyboard
  # @param down [String] expected keyboard key for the down movement
  # @return [Boolean] is it allowed to move down?
  def move_right?(event, right)
    max_x = constraints.dig(:x, :max)
    event.key == right && (!max_x || x + speed + height <= max_x)
  end
end
