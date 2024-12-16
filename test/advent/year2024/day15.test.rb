# https://adventofcode.com/2024/day/15
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 15)
Grid = Advent::Grid
Point = Advent::Point
Box = Advent::Year2024::Day15::Box
challenge.parse_input

# test "part 1" do
#   challenge.parse_input
#   expect(challenge.part1) == 10092
# end

# test "part 2" do
#   expect(challenge.part2) == 9021
# end

test "render" do
  puts ""
  challenge.parse_input
  challenge.parse_wide_grid

  challenge.directions.each do |d|
    challenge.wide_tick(d)
    challenge.render_grid
    sleep(0.7)
  end

  # 4.times do
  #   d = challenge.directions.shift
  #   challenge.wide_tick(d)
  # end
  # challenge.render_grid
end

# test "parse input" do
#   challenge.parse_input
#   assert challenge.grid.is_a?(Grid)
#   assert challenge.directions.is_a?(Array)
# end
#
# test "origin" do
#   challenge.parse_input
#   assert challenge.grid.is_a?(Grid)
#   assert challenge.origin == Point.new(4, 4)
# end
#
# test "boxes" do
#   challenge = Advent::Challenge.get_with_sample(year: 2024, day: 15)
#   challenge.parse_input
#   assert challenge.boxes.size == 21
#   assert challenge.boxes.first == Box.new(3, 1)
# end
#
# test "walls" do
#   challenge.parse_input
#   assert challenge.grid.is_a?(Grid)
#   assert challenge.walls.size == 37
#   assert challenge.walls.first == Point.new(0, 0)
# end
#
# test "direction" do
#   challenge.parse_input
#   assert challenge.grid.is_a?(Grid)
#   assert challenge.directions.first == Point.new(-1, 0)
# end
#
# test "Box#score" do
#   box = Box.new(3, 1)
#   assert box.score == 103
# end
#
# test "Boxes include" do
#   boxes = [Box.new(1, 1)]
#   assert boxes.include?(Point.new(1, 1))
# end
#
# test "do_east_west_movement one block west" do
#   challenge.reset_state
#   challenge.boxes = Set.new
#   challenge.walls = Set.new
#   box = Box.new(1, 0)
#   challenge.do_east_west_movement(box, Point::W)
#
#   assert challenge.boxes.to_a.first == Box.new(0, 0)
# end
#
# test "do_east_west_movement one block east" do
#   challenge.reset_state
#   challenge.boxes = Set.new
#   challenge.walls = Set.new
#   box = Box.new(1, 0)
#   challenge.do_east_west_movement(box, Point::E)
#
#   assert challenge.boxes.to_a.first == Box.new(2, 0)
# end
#
# test "do_east_west_movement two blocks west" do
#   challenge.reset_state
#   boxes = [Box.new(1, 0), Box.new(3, 0)]
#   box = boxes.last
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([])
#   challenge.do_east_west_movement(box, Point::W)
#
#   assert challenge.boxes.to_a.sort == [Box.new(0, 0), Box.new(2, 0)]
# end
#
# test "do_east_west_movement two blocks east" do
#   challenge.reset_state
#   boxes = [Box.new(1, 0), Box.new(3, 0)]
#   box = boxes.first
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([])
#   challenge.do_east_west_movement(box, Point::E)
#
#   assert challenge.boxes.to_a.sort == [Box.new(2, 0), Box.new(4, 0)]
# end
#
# test "do_east_west_movement two blocks east, one wall" do
#   challenge.reset_state
#   boxes = [Box.new(1, 0), Box.new(3, 0)]
#   box = boxes.first
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([Point.new(5, 0)])
#   challenge.do_east_west_movement(box, Point::E)
#
#   assert challenge.boxes.to_a.sort == [Box.new(1, 0), Box.new(3, 0)]
# end
#
# test "do_north_south_movement one block north" do
#   challenge.reset_state
#   boxes = [Box.new(0, 1)]
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new
#   box = boxes.first
#   challenge.do_north_south_movement(box, Point::N)
#
#   assert challenge.boxes.to_a.first == Box.new(0, 0)
# end
#
# test "do_north_south_movement one block south" do
#   challenge.reset_state
#   boxes = [Box.new(0, 1)]
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new
#   box = boxes.first
#   challenge.do_north_south_movement(box, Point::S)
#
#   assert challenge.boxes.to_a.first == Box.new(0, 2)
# end
#
# test "do_north_south_movement two blocks north" do
#   challenge.reset_state
#   boxes = [Box.new(0, 1), Box.new(0, 2)]
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([])
#   box = boxes.last
#   challenge.do_north_south_movement(box, Point::N)
#   # puts "---"
#   # pp challenge.boxes
#   assert challenge.boxes.to_a.sort == [Box.new(0, 0), Box.new(0, 1)]
# end
#
# test "do_north_south_movement offset blocks" do
#   challenge.reset_state
#   #
#   #[][]
#   # []
#   # ^
#   boxes = [Box.new(0, 1), Box.new(2, 1), Box.new(1, 2)]
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([])
#   box = boxes.last
#   challenge.do_north_south_movement(box, Point::N)
#   assert challenge.boxes.to_a.sort == [Box.new(0, 0), Box.new(2, 0), Box.new(1, 1)].sort
# end
#
# test "do_north_south_movement offset blocks with wall" do
#   challenge.reset_state
#   # #
#   #[][]
#   # []
#   # ^
#   boxes = [Box.new(0, 1), Box.new(2, 1), Box.new(1, 2)]
#   challenge.boxes = Set.new(boxes)
#   challenge.walls = Set.new([Point.new(1, 0)])
#   box = boxes.last
#   challenge.do_north_south_movement(box, Point::N)
#   assert challenge.boxes.to_a.sort == [Box.new(0, 1), Box.new(2, 1), Box.new(1, 2)].sort
# end
