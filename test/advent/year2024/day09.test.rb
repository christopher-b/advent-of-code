# https://adventofcode.com/2024/day/9
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 9)
DiskMap = Advent::Year2024::Day09::DiskMap
# File = Advent::Year2024::Day09::File

test "part 1" do
  # expect(challenge.compacted_disk_map.render) == "0099811188827773336446555566"
  expect(challenge.part1) == 1928
end

test "part 2" do
  # expect(challenge.disk_map.render(challenge.disk_map.smart_compact_files)) == "00992111777.44.333....5555.6666.....8888.."
  expect(challenge.part2) == 2858
end

test "DiskMap#initialize" do
 disk_map = DiskMap.new("12345")
 expect(disk_map.files) == %w[0 -1 -1 1 1 1 -1 -1 -1 -1 2 2 2 2 2].map(&:to_i)
end

test "DiskMap#blank_indicies" do
  disk_map = DiskMap.new("12345")
  expect(disk_map.blank_indicies) == [1, 2, 6, 7, 8, 9]
end

test "DiskMap#compact" do
  disk_map = DiskMap.new("12345")
  disk_map.compact
  expect(disk_map.files) == %w[0 2 2 1 1 1 2 2 2].map(&:to_i)
end

# test "DiskMap#checksum" do
#   disk_map = DiskMap.new("12345")
#   disk_map.compact
#   expect(disk_map.checksum) == 35
# end
