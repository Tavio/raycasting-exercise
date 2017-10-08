module Crystal::Wolf3d
  class Player
    ROTATION_SPEED = 100.0
    MOVE_SPEED     = 100.0

    @look_dir : Vector2D
    @camera_plane : Vector2D

    def initialize(@pos : Vector2D, @grid : Grid, look_dir : Vector2D, field_of_view : Float64)
      @look_dir = look_dir.unit
      @camera_plane = @look_dir.perpendicular * field_of_view
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

    def camera_plane
      @camera_plane
    end

    def rotate_left(frame_time)
      angle = frame_time * ROTATION_SPEED
      @look_dir = @look_dir.rotate(-angle)
      @camera_plane = @camera_plane.rotate(-angle)
    end

    def rotate_right(frame_time)
      angle = frame_time * ROTATION_SPEED
      @look_dir = @look_dir.rotate(angle)
      @camera_plane = @camera_plane.rotate(angle)
    end

    def move_forward(frame_time)
      distance = frame_time * MOVE_SPEED
      @pos += @look_dir * distance unless @grid.wall_at?((@pos + @look_dir).floor)
    end

    def move_backward(frame_time)
      distance = frame_time * MOVE_SPEED
      @pos -= @look_dir * distance unless @grid.wall_at?((@pos - @look_dir).floor)
    end
  end
end
