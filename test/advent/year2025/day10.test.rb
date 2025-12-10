# https://adventofcode.com/2025/day/10
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 10)
Machine = Advent::Year2025::Day10::Machine

test "part 1" do
  assert_equal 7, challenge.part1
end

test "part 2" do
  assert_equal 33, challenge.part2
end

test "solve" do
  assert_equal 2, challenge.machines[0].solve_lights
  assert_equal 3, challenge.machines[1].solve_lights
  assert_equal 2, challenge.machines[2].solve_lights
end

test "solve joltage" do
  assert_equal 10, challenge.machines[0].solve_joltage
  assert_equal 12, challenge.machines[1].solve_joltage
  assert_equal 11, challenge.machines[2].solve_joltage
end

test "targets" do
  assert_equal "110", challenge.machines[0].lights_target.to_s(2)
  assert_equal "10", challenge.machines[1].lights_target.to_s(2)
  assert_equal "11101", challenge.machines[2].lights_target.to_s(2)
end

test "buttons" do
  assert_equal "0001", challenge.machines[0].button_masks[0].to_s(2).rjust(4, "0")
  assert_equal "0101", challenge.machines[0].button_masks[1].to_s(2).rjust(4, "0")
  assert_equal "0010", challenge.machines[0].button_masks[2].to_s(2).rjust(4, "0")
  assert_equal "0011", challenge.machines[0].button_masks[3].to_s(2).rjust(4, "0")
  assert_equal "1010", challenge.machines[0].button_masks[4].to_s(2).rjust(4, "0")
  assert_equal "1100", challenge.machines[0].button_masks[5].to_s(2).rjust(4, "0")
end

test "joltage targets" do
  assert_equal [3, 5, 4, 7], challenge.machines[0].joltage_target
  assert_equal [7, 5, 12, 7, 2], challenge.machines[1].joltage_target
  assert_equal [10, 11, 11, 5, 10, 5], challenge.machines[2].joltage_target
end
