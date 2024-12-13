# https://adventofcode.com/2024/day/13
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 13)

test "part 1" do
  expect(challenge.part1) == 480
end

test "part 2" do
  expect(challenge.part2) == 875318608908
end

test "claw_machines" do
  assert challenge.claw_machines.size == 4
  assert challenge.claw_machines.first.ax == 94
end

test "extract_button" do
  assert challenge.extract_button("Button A: X+94, Y+34") == [94, 34]
end

test "extract_prize" do
  assert challenge.extract_prize("Prize: X=8400, Y=5400") == [8400, 5400]
end

test "find_solution" do
  assert challenge.claw_machines.first.solution == [80, 40]
end
