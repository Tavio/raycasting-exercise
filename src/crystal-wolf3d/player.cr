module Crystal::Wolf3d
  class Player
    def initialize(pos : Vector2D, look_dir : Vector2D)
      @pos = pos
      @look_dir = look_dir
    end

    def pos
      @pos
    end

    def pos=(position : Vector2D)
      @pos = position
    end

    def look_dir
      @look_dir
    end
  end
end
