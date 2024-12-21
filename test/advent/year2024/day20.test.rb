# https://adventofcode.com/2024/day/20
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 20)
Point = Advent::Point

test "part 1" do
  # assert_equal 0, challenge.part1
end

test "part 2" do
  # assert_equal 0, challenge.part2
end

test "origin" do
  assert_equal Point.new(1, 3), challenge.origin
end

test "path" do
  assert_equal 85, challenge.path.size
end

test "shortcuts" do
  assert_equal 44, challenge.shortcuts.values.size
end

test "shortcut_times" do
  times = [2] * 14 + [4] * 14 + [6] * 2 + [8] * 4 + [10] * 2 + [12] * 3 + [20] + [36] + [38] + [40] + [64]
  assert_equal times, challenge.shortcut_times.sort
end
