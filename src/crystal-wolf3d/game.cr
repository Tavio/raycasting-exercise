require "sdl"

module Crystal::Wolf3d
  class Game
    SCREEN_WIDTH       =  320
    SCREEN_HEIGHT      =  240
    CAMERA_PLANE_RATIO = 0.66

    def initialize
      SDL.init(SDL::Init::VIDEO)
      at_exit { SDL.quit }
      window = SDL::Window.new("Wolf 3D", SCREEN_WIDTH, SCREEN_HEIGHT)
      renderer = SDL::Renderer.new(window)

      look_dir = Vector2D.new(1.0, 0.5).unit
      camera_plane = look_dir.perpendicular * CAMERA_PLANE_RATIO
      player = Player.new(Vector2D.new(4.5, 6.5), look_dir)

      curr_time = Time.now.epoch_ms

      loop do
        renderer.draw_color = SDL::Color[0, 0, 0, 0]
        renderer.clear

        column = 0
        while column <= SCREEN_WIDTH
          camera_x = 2 * column / SCREEN_WIDTH.to_f - 1
          ray = look_dir + camera_plane * camera_x
          wall_pos, side_hit, step_x, step_y = find_wall(player, ray, Grid::GRID)
          draw_wall(player.pos, wall_pos, ray, step_x, step_y, column, side_hit, renderer)
          column += 1
        end

        renderer.present

        last_time = curr_time
        curr_time = Time.now.epoch_ms
        frame_time = (curr_time - last_time) / 1000.0
        rotation_speed = frame_time * 100.0
        move_speed = frame_time * 100.0

        case event = SDL::Event.poll
        when SDL::Event::Quit
          break
        when SDL::Event::Keyboard
          case event.sym
          when .right?
            look_dir = look_dir.rotate(rotation_speed)
            camera_plane = camera_plane.rotate(rotation_speed)
          when .left?
            look_dir = look_dir.rotate(-rotation_speed)
            camera_plane = camera_plane.rotate(-rotation_speed)
          when .up?
            player.pos += look_dir * move_speed
          when .down?
            player.pos -= look_dir * move_speed
          end if event.keydown?
        end
      end
    end

    private def draw_vector(renderer : SDL::Renderer, starting_point : Vector2D, direction : Vector2D, magnitude : Float64, color : SDL::Color)
      renderer.draw_color = color
      ending_point = starting_point + direction * magnitude
      renderer.draw_line(starting_point.x, starting_point.y, ending_point.x, ending_point.y)
    end

    private def draw_wall(player_pos : Vector2D, wall_pos : Vector2D, ray_dir : Vector2D, step_x : Int32, step_y : Int32, screen_x : Int32, side_hit, renderer : SDL::Renderer)
      # wall_distance = player_pos.orth_distance(wall_pos)
      if side_hit == :vertical
        wall_distance = (wall_pos.x - player_pos.x + (1 - step_x) / 2) / ray_dir.x
      else
        wall_distance = (wall_pos.y - player_pos.y + (1 - step_y) / 2) / ray_dir.y
      end

      wall_height = (SCREEN_HEIGHT / wall_distance).to_i

      draw_start = SCREEN_HEIGHT / 2 - wall_height / 2
      draw_start = 0 if draw_start < 0
      draw_end = SCREEN_HEIGHT / 2 + wall_height / 2
      draw_end = SCREEN_HEIGHT - 1 if draw_end >= SCREEN_HEIGHT

      renderer.draw_color = SDL::Color[255, 0, 0, 0]
      renderer.draw_line(screen_x, draw_start, screen_x, draw_end)
    end

    private def find_wall(player : Player, ray_dir : Vector2D, grid)
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
          side_hit = :vertical
        else
          side_dist_y += delta_dist_y
          curr_cell_y += step_y
          side_hit = :horizontal
        end
        if grid[curr_cell_y][curr_cell_x] > 0
          return {Vector2D.new(curr_cell_x.to_f, curr_cell_y.to_f), side_hit, step_x, step_y}
        end
      end
    end
  end
end
