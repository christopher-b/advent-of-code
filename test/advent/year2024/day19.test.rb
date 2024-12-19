# https://adventofcode.com/2024/day/19
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 19)

test "part 1" do
  assert_equal 6, challenge.part1
end

test "part 2" do
  assert_equal 16, challenge.part2
end

test "designs" do
  assert_equal 8, challenge.designs.size
  assert_equal "brwrr", challenge.designs.first
end

# test "towels" do
#   assert_equal 8, challenge.towels.size
#   assert_equal "r", challenge.towels.first
# end
