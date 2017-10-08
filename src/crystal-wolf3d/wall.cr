module Crystal::Wolf3d
  enum SideHit
    Vertical
    Horizontal
  end

  class Wall
    def initialize(pos : Vector2D, side_hit : SideHit, step_x : Int32, step_y : Int32, ray_dir : Vector2D, screen_x : Int32)
      @pos = pos
      @side_hit = side_hit
      @step_x = step_x
      @step_y = step_y
      @ray_dir = ray_dir
      @screen_x = screen_x
    end

    def draw(player_pos : Vector2D, renderer : SDL::Renderer, screen_height : Int32)
      if @side_hit.vertical?
        wall_distance = (@pos.x - player_pos.x + (1 - @step_x) / 2) / @ray_dir.x
      else
        wall_distance = (@pos.y - player_pos.y + (1 - @step_y) / 2) / @ray_dir.y
      end

      wall_height = (screen_height / wall_distance).to_i

      draw_start = screen_height / 2 - wall_height / 2
      draw_start = 0 if draw_start < 0
      draw_end = screen_height / 2 + wall_height / 2
      draw_end = screen_height - 1 if draw_end >= screen_height

      renderer.draw_color = SDL::Color[255, 0, 0, 0]
      renderer.draw_line(@screen_x, draw_start, @screen_x, draw_end)
    end
  end
end
