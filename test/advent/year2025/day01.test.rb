# https://adventofcode.com/2025/day/1
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 1)
Rotation = Advent::Year2025::Day01::Rotation

test "part 1" do
  # assert_equal 3, challenge.part1
end

test "part 2" do
  # assert_equal 6, challenge.part2
end

test "zero_passes" do
  # 10 - 20: 1
  rotation = Rotation.new("L", 20)
  rotation.apply(10)
  assert_equal 1, rotation.zero_passes

  # 90 + 20: 1
  rotation = Rotation.new("R", 20)
  rotation.apply(90)
  assert_equal 1, rotation.zero_passes

  # 10 - 10: 1
  rotation = Rotation.new("L", 10)
  rotation.apply(10)
  assert_equal 1, rotation.zero_passes

  # 90 + 10: 1
  rotation = Rotation.new("R", 10)
  rotation.apply(90)
  assert_equal 1, rotation.zero_passes

  # 0 - 10: 0
  rotation = Rotation.new("L", 10)
  rotation.apply(0)
  assert_equal 0, rotation.zero_passes

  # 0 + 10: 0
  rotation = Rotation.new("R", 10)
  rotation.apply(0)
  assert_equal 0, rotation.zero_passes

  # 10 + 200: 2
  rotation = Rotation.new("R", 200)
  rotation.apply(10)
  assert_equal 2, rotation.zero_passes

  # 10 - 200: 2
  rotation = Rotation.new("L", 200)
  rotation.apply(10)
  assert_equal 2, rotation.zero_passes
end
