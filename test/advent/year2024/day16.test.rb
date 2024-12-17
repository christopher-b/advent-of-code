# https://adventofcode.com/2024/day/16
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 16)
Point = Advent::Point
Vector = Advent::Vector

test "part 1" do
  # (challenge.part1)
  expect(challenge.part1) == 7036
end

test "part 2" do
  expect(challenge.part2) == 45
end

# test "#origin" do
#   expect(challenge.origin) == Vector.new(Point.new(1, 13), Point::E)
# end
#
# test "#finish" do
#   expect(challenge.finish) == Point.new(13, 1)
# end
#
# test "#walls" do
#   assert challenge.walls.size == 121
# end
#
# test "#path_direction" do
#   current = Point.new(1, 1)
#   n_point = Point.new(1, 0)
#   s_point = Point.new(1, 2)
#   e_point = Point.new(2, 1)
#   w_point = Point.new(0, 1)
#
#   assert challenge.path_direction(current, n_point) == Point::N
#   assert challenge.path_direction(current, s_point) == Point::S
#   assert challenge.path_direction(current, e_point) == Point::E
#   assert challenge.path_direction(current, w_point) == Point::W
# end
