module Crystal::Wolf3d
  class Grid
    GRID = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 1, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]

    CELL_SIZE = 64.0

    def num_rows
      GRID.size
    end

    def num_columns
      GRID[0].size
    end

    def self.grid_pos(world_pos : Vector2D)
      world_pos / CELL_SIZE
    end

    def self.world_pos(grid_pos_x : Int32, grid_pos_y : Int32)
      Vector2D.new(grid_pos_x, grid_pos_y)
    end
  end
end
