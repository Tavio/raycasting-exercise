module Crystal::Wolf3d
  class Raycaster
    def trace_walls(screen_width : Int32, player : Player, look_dir : Vector2D, camera_plane : Vector2D, grid)
      walls = [] of Wall
      column = 0
      while column <= screen_width
        camera_x = 2 * column / screen_width.to_f - 1
        ray = look_dir + camera_plane * camera_x
        walls << trace_wall(player, ray, column, grid)
        column += 1
      end
      return walls
    end

    private def trace_wall(player : Player, ray_dir : Vector2D, screen_x : Int32, grid)
      curr_cell_x = player.pos.x.to_i
      curr_cell_y = player.pos.y.to_i
      x_distance_between_rows = ray_dir.y == 0 ? Float64::INFINITY : ray_dir.x / ray_dir.y
      y_distance_between_columns = ray_dir.x == 0 ? Float64::INFINITY : ray_dir.y / ray_dir.x
      delta_dist_x = Math.sqrt(1 + y_distance_between_columns / x_distance_between_rows)
      delta_dist_y = Math.sqrt(1 + x_distance_between_rows / y_distance_between_columns)

      if ray_dir.x < 0
        step_x = -1
        side_dist_x = delta_dist_x * (player.pos.x - curr_cell_x)
      else
        step_x = 1
        side_dist_x = delta_dist_x * (curr_cell_x + 1.0 - player.pos.x)
      end

      if ray_dir.y < 0
        step_y = -1
        side_dist_y = delta_dist_y * (player.pos.y - curr_cell_y)
      else
        step_y = 1
        side_dist_y = delta_dist_y * (curr_cell_y + 1.0 - player.pos.y)
      end

      while true
        if side_dist_x < side_dist_y
          side_dist_x += delta_dist_x
          curr_cell_x += step_x
          side_hit = SideHit::Vertical
        else
          side_dist_y += delta_dist_y
          curr_cell_y += step_y
          side_hit = SideHit::Horizontal
        end
        if grid[curr_cell_y][curr_cell_x] > 0
          return Wall.new(Vector2D.new(curr_cell_x.to_f, curr_cell_y.to_f), side_hit, step_x, step_y, ray_dir, screen_x)
        end
      end
    end
  end
end
