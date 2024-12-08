Grid = Advent::Grid
Point = Advent::Point

test "#in_range?" do
  grid = Grid.new([[1]])
  assert grid.in_range?(Point.new(0, 0))
  refute grid.in_range?(Point.new(1, 0))
  refute grid.in_range?(Point.new(0, 1))
  refute grid.in_range?(Point.new(1, 1))
  refute grid.in_range?(Point.new(-1, 0))
  refute grid.in_range?(Point.new(0, -1))
  refute grid.in_range?(Point.new(-1, -1))
end
