module Crystal::Wolf3d
  class Raycaster
    def initialize(@grid : Grid)
    end

    def trace_walls(screen_width : Int32, player : Player)
      walls = [] of Wall
      column = 0
      while column <= screen_width
        camera_x = 2 * column / screen_width.to_f - 1
        ray = player.look_dir + player.camera_plane * camera_x
        walls << trace_wall(player, ray, column)
        column += 1
      end
      return walls
    end

    private def trace_wall(player : Player, ray_dir : Vector2D, screen_x : Int32)
      curr_cell = player.pos.floor
      x_distance_between_rows = ray_dir.y == 0 ? Float64::INFINITY : ray_dir.x / ray_dir.y
      y_distance_between_columns = ray_dir.x == 0 ? Float64::INFINITY : ray_dir.y / ray_dir.x
      delta_dist_x = Math.sqrt(1 + y_distance_between_columns / x_distance_between_rows)
      delta_dist_y = Math.sqrt(1 + x_distance_between_rows / y_distance_between_columns)

      if ray_dir.x < 0
        step_x = -1
        side_dist_x = delta_dist_x * (player.pos.x - curr_cell.x)
      else
        step_x = 1
        side_dist_x = delta_dist_x * (curr_cell.x + 1.0 - player.pos.x)
      end

      if ray_dir.y < 0
        step_y = -1
        side_dist_y = delta_dist_y * (player.pos.y - curr_cell.y)
      else
        step_y = 1
        side_dist_y = delta_dist_y * (curr_cell.y + 1.0 - player.pos.y)
      end

      while true
        if side_dist_x < side_dist_y
          side_dist_x += delta_dist_x
          curr_cell.x += step_x
          side_hit = SideHit::Vertical
        else
          side_dist_y += delta_dist_y
          curr_cell.y += step_y
          side_hit = SideHit::Horizontal
        end
        if @grid.wall_at?(curr_cell)
          return Wall.new(Vector2D.new(curr_cell.x.to_f, curr_cell.y.to_f), side_hit, step_x, step_y, ray_dir, screen_x)
        end
      end
    end
  end
end
