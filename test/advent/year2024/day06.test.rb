# https://adventofcode.com/2024/day/6
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 6)
Point = Advent::Year2024::Day06::Point
Cursor = Advent::Year2024::Day06::Cursor
Vector = Advent::Year2024::Day06::Vector

origin = Vector.new(Point.new(0, 0), Point.new(0, -1))

test "part 1" do
  assert challenge.part1 == 41
end

test "part 2" do
  expect(challenge.part2) == 6
end

test "origin" do
  assert challenge.origin == Vector.new(Point.new(4, 6), Point.new(0, -1))
end

test "cursor rotate" do
  cursor = Cursor.new(origin)

  cursor.rotate
  assert cursor.direction == Advent::Year2024::Day06::RIGHT
  cursor.rotate
  assert cursor.direction == Advent::Year2024::Day06::DOWN
  cursor.rotate
  assert cursor.direction == Advent::Year2024::Day06::LEFT
  cursor.rotate
  assert cursor.direction == Advent::Year2024::Day06::UP
  cursor.rotate
  assert cursor.direction == Advent::Year2024::Day06::RIGHT
end

test "cursor step" do
  cursor = Cursor.new(Vector.new(Point.new(0, 0), Point.new(0, 1)))

  cursor.step
  assert cursor.position == Point.new(0, 1)
end

test "cursor walk" do
  cursor = Cursor.new(origin)
  cursor.rotate
  cursor.step
  assert(cursor.position == Point.new(1, 0))
  cursor.step
  assert(cursor.position == Point.new(2, 0))
  cursor.rotate
  cursor.step
  assert(cursor.position == Point.new(2, 1))
end

test "valid position" do
  assert challenge.valid_position?(Point.new(0, 0))
  refute challenge.valid_position?(Point.new(-1, 0))
  refute challenge.valid_position?(Point.new(10, 1))
end

test "point equality" do
  p1 = Point.new(1, 2)
  p2 = Point.new(1, 2)
  assert p1 == p2
  refute Point.new(1, 2) == Point.new(2, 1)
end

test "point triple equality" do
  p1 = Point.new(1, 2)
  p2 = Point.new(1, 2)
  assert p1 === p2
  # refute Point.new(1, 2, 3) == Point.new(2, 1, 3)
end

test "vector equality" do
  v1 = Vector.new(Point.new(1, 2), Point.new(0, 1))
  v2 = Vector.new(Point.new(1, 2), Point.new(0, 1))
  v3 = Vector.new(Point.new(1, 2), Point.new(1, 0))
  assert v1 == v2
  refute v1 == v3
end

test "is_obstacle?" do
  assert challenge.is_obstacle?(Point.new(4, 0))
  refute challenge.is_obstacle?(Point.new(0, 0))

  assert challenge.is_obstacle?(Point.new(0, 1), Point.new(0, 1))
end