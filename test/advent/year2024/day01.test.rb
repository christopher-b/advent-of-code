day_info = DayInfo.new(2024, 1)
challenge = day_info.challenge_with_sample

test "part 1" do
  assert challenge.part1 == 11
end

test "part 2" do
  assert challenge.part2 == 31
end

test "build lists" do
  list1, _list2 = challenge.lists
  assert list1.size == 6
  assert list1.first == 1
end

test "calculate distance" do
  list1 = [1, 1]
  list2 = [2, 2]
  assert challenge.distance(list1, list2) == 2
end

test "calculate similarity" do
  list1 = [3]
  list2 = [3, 3, 3]
  assert challenge.similarity(list1, list2) == 9
end
