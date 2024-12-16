# https://adventofcode.com/2024/day/15
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 15)
Grid = Advent::Grid
Point = Advent::Point
Box = Advent::Year2024::Day15::Box
BigBox = Advent::Year2024::Day15::BigBox
challenge.parse_input

test "part 1" do
  challenge.reset_state
  challenge.parse_input
  expect(challenge.part1) == 10092
end

test "part 2" do
  expect(challenge.part2) == 9021
end

test "boxes" do
  challenge.reset_state
  challenge.parse_input
  assert challenge.boxes.size == 21
end

test "Box#push" do
  box = Box.new(1, 1)
  box.push(Point::N)
  assert box == Point.new(1, 0)
end

test "Box#push with wall" do
  box = Box.new(1, 1)
  box.walls = {Point.new(1, 0) => true}
  box.push(Point::N)
  assert box == Point.new(1, 1)
end

test "Box#push with box" do
  box = Box.new(1, 1)
  box2 = Box.new(2, 1)
  box.boxes = {box2 => box2}
  box.push(Point::E)
  assert box = Point.new(2, 1)
  assert box2 = Point.new(3, 1)
end

test "Box#push with box and wall" do
  box = Box.new(1, 1)
  box2 = Box.new(2, 1)
  box.boxes = {box2 => box2}
  box2.walls = {Point.new(3, 1) => true}
  box.push(Point::E)
  assert box = Point.new(1, 1)
  assert box2 = Point.new(2, 1)
end

test "BigBox#vertical_sides" do
  box = BigBox.new(1, 1)
  assert box.vertical_sides(Point::N) == [Point.new(1, 0), Point.new(2, 0)]
end

test "BigBox#vertical_neighbors none" do
  box = BigBox.new(1, 1)
  assert box.vertical_neighbors(Point::N) == []
end

test "BigBox#vertical_neighbors one" do
  box = BigBox.new(1, 1)
  neighbor = BigBox.new(1, 0)
  box.boxes = {neighbor => neighbor}
  assert box.vertical_neighbors(Point::N) == [neighbor]
end

test "BigBox#vertical_neighbors two" do
  box = BigBox.new(1, 1)
  neighbor1 = BigBox.new(1, 0)
  neighbor2 = BigBox.new(2, 0)
  box.boxes = {neighbor1 => neighbor1, neighbor2 => neighbor2}
  assert box.vertical_neighbors(Point::N) == [neighbor1, neighbor2]
end
