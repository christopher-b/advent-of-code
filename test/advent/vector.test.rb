Vector = Advent::Vector
Point = Advent::Point

test "#from_points" do
  a = Point.new(0, 0)
  b = Point.new(1, 1)
  vector = Vector.from_points(a, b)
  assert vector.position == a
  assert vector.direction == Point.new(1, 1)
end
