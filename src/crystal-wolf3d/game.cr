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
      raycaster = Raycaster.new

      look_dir = Vector2D.new(1.0, 0.5).unit
      camera_plane = look_dir.perpendicular * CAMERA_PLANE_RATIO
      player = Player.new(Vector2D.new(4.5, 6.5), look_dir)

      curr_time = Time.now.epoch_ms

      loop do
        renderer.draw_color = SDL::Color[0, 0, 0, 0]
        renderer.clear

        walls = raycaster.trace_walls(SCREEN_WIDTH, player, look_dir, camera_plane, Grid::GRID)
        walls.each { |wall| wall.draw(player.pos, renderer, SCREEN_HEIGHT) }

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
  end
end
