# https://adventofcode.com/2024/day/18
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 18)
Point = Advent::Point

test "part 1" do
  assert_equal 22, challenge.part1
end

test "part 2" do
  assert_equal "6,1", challenge.part2
end

# test "bytes" do
#   assert_equal 25, challenge.bytes.size
#   assert_equal Point.new(5, 4), challenge.bytes.first
# end
#
# test "sample" do
#   assert_equal 12, challenge.sample.size
# end
