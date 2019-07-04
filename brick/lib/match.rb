# Deals with the logic of the brick's match.
# @author Miłosz Osiński <milosz@icoded.com>
class Match
  attr_accessor :paused, :score, :reseted_at

  # @api public
  # @return [Match]
  def initialize
    @score  = { left: 0, right: 0 }
    @paused = true
  end

  # @api public
  # @return [Boolaen]
  alias paused? paused

  # @api public
  # @return [Boolaen]
  def wait_to_start?
    !reseted_at.nil?
  end

  # @api public
  # @return [nil]
  def check_wait!(current_frame)
    self.reseted_at = nil if current_frame - reseted_at >= 60
  end

  # @api public
  # @param window [Window] the game's window
  # @param ball [Ball] the game's ball
  # @param pad [Pad] the game's pad
  # @return [Ingeter]
  def restart!(window, ball, pad)
    ball.scored_at = nil
    ball.failed_at = nil
    ball.reset_position!(window, pad)
    self.reseted_at = window.get(:frames)
  end
end
