# https://adventofcode.com/2025/day/8
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 8)
challenge.connections = 10
ThreePoint = Advent::Year2025::Day08::ThreePoint

test "part 1" do
  assert_equal 40, challenge.part1
end

test "part 2" do
  assert_equal 25272, challenge.part2
end

test "distances" do
  a = ThreePoint.new(906, 360, 560)
  b = ThreePoint.new(805, 96, 715)

  assert_equal a.sort_distance(b), b.sort_distance(a)
end
