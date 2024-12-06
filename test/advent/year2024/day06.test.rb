# https://adventofcode.com/2024/day/6
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 6)
Point = Advent::Year2024::Day06::Point
Cursor = Advent::Year2024::Day06::Cursor
origin = Point.new(0, 0)

test "part 1" do
  assert challenge.part1 == 41
end

test "part 2" do
  assert challenge.part2 == 6
end

test "origin" do
  assert challenge.origin == Point.new(4, 6)
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
  cursor = Cursor.new(origin, Advent::Year2024::Day06::RIGHT)

  cursor.step
  assert cursor.position == Point.new(1, 0)
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

# test "loop detection" do
#   expect { challenge.walk(Point.new(3, 6)) }.to_raise(Advent::Year2024::Day06::LoopException)
# end
