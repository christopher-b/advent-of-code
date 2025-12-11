# https://adventofcode.com/2025/day/9
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 9)

test "part 1" do
  assert_equal 50, challenge.part1
end

test "part 2" do
  assert_equal 24, challenge.part2
end

# test "corners" do
#   pp challenge.perimeter_corners
# end
#
# pp challenge.perimeter_segments
