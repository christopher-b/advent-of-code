# https://adventofcode.com/2024/day/14
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 14)
challenge.grid = Advent::Point.new(11, 7)
Point = Advent::Point
Vector = Advent::Vector
Robot = Advent::Year2024::Day14::Robot

test "part 1" do
  expect(challenge.part1) == 12
end

test "part 2" do
  # Can't really test this. There's no tree in the test input
  # expect(challenge.part2) == 0
end

test "robots" do
  assert challenge.robots.size == 12

  p1 = Point.new(0, 4)
  p2 = Point.new(3, -3)
  assert challenge.robots.first.vector == Vector.new(p1, p2)
end

test "Robot#step" do
  position = Point.new(0, 0)
  direction = Point.new(2, 2)
  grid = Point.new(3, 3)

  robot = Robot.new(position, direction, grid)
  robot = robot.step
  assert robot.position == Point.new(2, 2)

  # Wrap
  robot = robot.step
  assert robot.position == Point.new(1, 1)
end

# test "render_grid" do
#   2.times do
#     challenge.robots.each(&:step)
#   end
#   challenge.render_grid
# end
