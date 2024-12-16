# https://adventofcode.com/2024/day/15
module Advent
  module Year2024
    class Day15 < Advent::Challenge
      # Explanation here
      # A lot of this works and is made much faster by implementing `hash` and `eql?` on the Point class

      attr_accessor :robot, :grid, :directions, :walls, :boxes

      def part1
        directions.each { |d| tick(d) }
        boxes.sum(&:score)
      end

      # 4173127 too high
      def part2
        parse_wide_grid
        # directions.each { |d| wide_tick(d) }
        direction_size = directions.size
        directions.each_with_index do |d, i|
          puts "#{i} / #{direction_size}"
          wide_tick(d)
        end
        boxes.sum(&:score)
      end

      def tick(direction)
        next_position = robot + direction
        return if walls.include? next_position

        if boxes.include? next_position
          # Scan forward until we find a wall or empty space
          scan_position = next_position
          loop do
            scan_position = scan_position + direction

            return if walls.include? scan_position # If we find a wall, do nothing
            next if boxes.include? scan_position # If we find a box, keep scanning

            boxes.delete(next_position) # We found an empty space, move the box and the robot
            boxes << Box.new(scan_position.x, scan_position.y)

            @robot = next_position # Move the robot
            return
          end
        end

        # No other instructions
        @robot = next_position
      end

      def wide_tick(direction)
        next_position = robot + direction
        return if walls.include? next_position

        box = check_wide_boxes(next_position, direction)
        if box
          case direction
          when Point::E, Point::W
            do_east_west_movement(box, direction)
          when Point::N, Point::S
            do_north_south_movement(box, direction)
          end
        end

        @robot = next_position
      end

      def reset_state
        @robot = @origin = @walls = @boxes = nil
      end

      # Get double-wide box and wall positions
      def parse_wide_grid
        reset_state
        @boxes = Set.new
        @walls = Set.new
        chunks = input_text.split("\n\n")
        chunks[0].each_line.with_index do |line, y|
          line.each_char.with_index do |char, x|
            case char
            when "#"
              walls << Point.new(x + x, y)
              walls << Point.new(x + x + 1, y)
            when "O" then boxes << Box.new(x + x, y)
            when "@" then @robot = Point.new(x + x, y)
            end
          end
        end
      end

      # Check if there is a box in the given position & direction
      # Because boxes are only listed by their top-left corner, we need to check
      # adjacent squares, depending on direction
      def check_wide_boxes(position, direction)
        case direction
        when Point::N, Point::S
          if boxes.include? position
            position
          elsif boxes.include? position + Point::W
            position + Point::W
          else
            nil
          end
        when Point::E then position
        when Point::W then position + Point::W
        end
      end

      # Move the robot east or west, moving boxes as necessary
      # We already know we have one box to move
      # @param box [Box] The first box in the sequence
      # @param direction [Point] The direction to move
      # @next_position [Point] The position the robot will move to
      def do_east_west_movement(box, direction)
        boxes_to_move = Set.new([box])
        scan_position = box
        loop do
          scan_position = scan_position + direction + direction

          # Do nothing if we find a wall
          return if walls.include? scan_position

          # Collect a set of boxes to move
          if boxes.include? scan_position
            boxes_to_move << scan_position
            next
          end

          # Found a blank space
          boxes_to_move.each do |box_to_move|
            boxes.delete(box_to_move)
            boxes << Box.new(box_to_move.x + direction.x, box_to_move.y)
          end
          @robot = robot + direction
          return
        end
      end

      def do_north_south_movement(box, direction)
        # Do a recursive scan to find which boxes need to move.
        boxes_to_move = find_vertical_boxes(box, direction)

        # Move all boxes or no boxes
        return unless boxes_to_move

        boxes_to_move.reverse.each do |box|
          boxes.delete(box)
          boxes << Box.new(box.x, box.y + direction.y)
        end
        @robot = robot + direction
      end

      def find_vertical_boxes(box, direction)
        next_position_l = box + direction
        next_position_r = box + direction + Point::E

        return false if walls.include? next_position_l
        return false if walls.include? next_position_r

        # Find all boxes we might be pushing
        l_box = check_wide_boxes(next_position_l, direction)
        r_box = check_wide_boxes(next_position_r, direction)
        adjacent_boxes = [l_box, r_box].compact
        child_boxes = []
        adjacent_boxes.each do |adjacent_box|
          children = find_vertical_boxes(adjacent_box, direction)
          return false unless children
          child_boxes.concat(children)
        end

        return false if child_boxes.any? { |r| false == r }
        return [box, adjacent_boxes, child_boxes].flatten
      end

      def robot
        @robot ||= origin
      end

      def origin
        @origin ||= grid.each_char
          .find { |char, x, y| char == '@' }
          .then { |_, x, y| Point.new(x, y) }
      end

      def boxes
        @boxes ||= grid.each_char
          .select { |char, _, _| char == 'O' }
          .map { |_, x, y| Box.new(x, y) }
          .to_set
      end

      def walls
        @walls ||= grid.each_char
          .select { |char, _, _| char == '#' }
          .map { |_, x, y| Point.new(x, y) }
          .to_set
      end

      def parse_input
        reset_state
        chunks = input_text.split("\n\n")
        @grid = Grid.new(chunks[0].lines)
        @directions = chunks[1].chars.reject { |c| c == "\n" }.map do |char|
          case char
          when '^' then Point.new(0, -1)
          when '>' then Point.new(1, 0)
          when '<' then Point.new(-1, 0)
          when 'v' then Point.new(0, 1)
          end
        end
      end

      def render_grid
        output = String.new
        (0..grid.height - 1).each do |y|
          (0..grid.width * 2).each do |x|
            point = Point.new(x, y)
            if walls.include? point
              output << "#"
            elsif boxes.include? point
              output << "["
            elsif robot == point
              output << "@"
            else
              output << "."
            end
          end
          output << "\n"
        end
        puts output
      end

      class Box < Point
        def score = x + y * 100
      end
    end
  end
end
