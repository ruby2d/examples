class Union
  # A class that behaves like the mathematical union

  # @param sets [array] An array of shapes
  def initialize(sets)
    @sets = sets
  end

  # @param x_position [int] An x coordinate on the screen
  # @param y_position [int] An y coordinate on the screen
  # @return [bool] True if one of the shapes in sets contains the position
  def contains?(x_position,y_position)
    @sets.each do |set|
      if set.contains?(x_position,y_position)
        return true
      end
    end
    return false
  end

end
