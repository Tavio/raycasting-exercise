module Crystal::Wolf3d
  class Vector2D
    @mag : Float64?
    @unit : Vector2D?

    def initialize(x : Float64, y : Float64)
      @x = x
      @y = y
    end

    def x
      @x
    end

    def y
      @y
    end

    def x=(x_coord)
      @x = x_coord
    end

    def y=(y_coord)
      @y = y_coord
    end

    def mag
      @mag ||= Math.sqrt(@x ** 2 + @y ** 2)
    end

    def unit
      @unit ||= self / self.mag
    end

    def +(other_vector2D : Vector2D)
      Vector2D.new(@x + other_vector2D.x, @y + other_vector2D.y)
    end

    def -(other_vector2D : Vector2D)
      Vector2D.new(@x - other_vector2D.x, @y - other_vector2D.y)
    end

    def dot(other_vector2D : Vector2D)
      @x * other_vector2D.x + @y * other_vector2D.y
    end

    def *(c : Float64)
      Vector2D.new(@x * c, @y * c)
    end

    def /(c : Float64)
      Vector2D.new(@x / c, @y / c)
    end

    def perpendicular
      Vector2D.new(-@y, @x)
    end

    def projection(other_vector2D : Vector2D)
      other_vector2D.unit * self.dot(other_vector2D) / other_vector2D.mag
    end

    def orth_projection(other_vector2D : Vector2D)
      self - self.projection(other_vector2D)
    end

    def orth_distance(other_vector2D : Vector2D)
      self.orth_projection(other_vector2D).mag
    end

    def rotate(angle : Float64)
      Vector2D.new(@x * Math.cos(angle) - @y * Math.sin(angle), @x * Math.sin(angle) + @y * Math.cos(angle))
    end

    def euclidean_distance(other_vector2D : Vector2D)
      Math.sqrt((other_vector2D.x - x) ** 2 + (other_vector2D.y - y) ** 2)
    end

    def floor
      Vector2D.new(@x.floor, @y.floor)
    end

    def to_s(io)
      io << "Vector2D(#{@x}, #{@y})"
    end
  end
end
