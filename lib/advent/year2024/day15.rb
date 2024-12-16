# https://adventofcode.com/2024/day/15
module Advent
  module Year2024
    class Day15 < Advent::Challenge
      # A lot of this works and is made much faster by implementing `hash` and `eql?` on the Point class. I learned a lot about object equality and hashing!
      #
      # We keep track of boxes and walls in a hash, using the point value as the key. This way, we can make both cells of a wide box point to the same box instance
      # This took way longer than it should have. There were lots of weird bugs. And I rewrote the whole thing to be more OO, which was a good idea.

      attr_accessor :robot, :grid, :directions, :walls, :boxes

      def part1
        directions.each { |d| tick(d) }
        boxes.values.sum(&:score)
      end

      def part2
        parse_wide_grid
        directions.each { |d| tick(d) }
        boxes.values.uniq.sum(&:score)
      end

      class Box < Point
        attr_accessor :boxes, :walls

        def initialize(x, y, boxes: {}, walls: {})
          super(x, y)
          @boxes = boxes
          @walls = walls
        end

        def score = x + y * 100

        def push(direction)
          next_position = self + direction
          return false if walls[next_position]

          if neighbor = boxes[next_position]
            return false unless neighbor.push(direction)
          end

          update_position(direction)
        end

        def update_position(direction)
          boxes.delete(self)
          self.x += direction.x
          self.y += direction.y
          boxes[self] = self
        end

        def to_s
          "Box(#{x}, #{y})"
        end
      end

      class BigBox < Box
        def linked_cell
          self + Point::E
        end

        def west_side
          self + Point::W
        end

        def east_side
          linked_cell + Point::E
        end

        def vertical_sides(direction)
          [self + direction, linked_cell + direction]
        end

        def vertical_neighbors(direction)
          vertical_sides(direction).map { |side| boxes[side] }.compact.uniq
        end

        # Recursively check if any pushed neighbors can be pushed. Only for vertical checks
        def can_push?(direction)
          return false if vertical_sides(direction).any? { |side| walls[side] }
          return vertical_neighbors(direction).all? { |neighbor| neighbor.can_push?(direction) }
        end

        # Only for vertical pushes. We assume we have done a can_push? check
        def push!(direction)
          vertical_neighbors(direction).each do |neighbor|
            neighbor.push!(direction)
          end

          update_position(direction)
        end

        def push(direction)
          case direction
          when Point::N, Point::S
            # Check each child before attempting the push
            return false unless can_push?(direction)

            push!(direction)
          when Point::W
            return false if walls[west_side]

            if neighbor = boxes[west_side]
              return false unless neighbor.push(direction)
            end

            update_position(direction)
          when Point::E
            return false if walls[east_side]

            if neighbor = boxes[east_side]
              return false unless neighbor.push(direction)
            end

            update_position(direction)
          end

          true
        end

        def update_position(direction)
          boxes.delete(self)
          boxes.delete(linked_cell)

          next_position = self + direction
          self.x = next_position.x
          self.y = next_position.y

          boxes[self] = self
          boxes[linked_cell] = self
        end

        def to_s
          "BigBox(#{x}, #{y})"
        end
      end

      def tick(direction)
        next_position = robot + direction
        return if walls[next_position]

        if box = boxes[next_position]
          return unless box.push(direction)
        end

        @robot = next_position
      end

      def reset_state
        @robot = @origin = @walls = @boxes = nil
      end

      # Get double-wide box and wall positions
      # We store the same box instance for both cells of a double-wide box
      def parse_wide_grid
        reset_state
        @boxes = {}
        @walls = {}
        chunks = input_text.split("\n\n")
        chunks[0].each_line.with_index do |line, y|
          line.each_char.with_index do |char, x|
            case char
            when "#"
              wall = Point.new(x + x, y)
              walls[wall] = wall
              walls[wall + Point::E] = wall
            when "O"
              box = BigBox.new(x + x, y)
              boxes[box] = box
              boxes[box + Point::E] = box
            when "@" then @robot = Point.new(x + x, y)
            end
          end
        end

        # Populate the boxes with global state
        boxes.values.each { |box| box.boxes = boxes; box.walls = walls }
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
          .map { |_, x, y| box = Box.new(x, y); [box, box] }
          .to_h
      end

      def walls
        @walls ||= grid.each_char
          .select { |char, _, _| char == '#' }
          .map { |_, x, y| wall = Point.new(x, y), [wall, wall] }
          .to_h
      end

      def parse_input
        # reset_state
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

        boxes.values.each { |box| box.boxes = boxes; box.walls = walls }
      end

      def render_grid
        output = String.new
        (0..grid.height - 1).each do |y|
          (0..grid.width * 2).each do |x|
            point = Point.new(x, y)
            if walls[point]
              output << "#"
            elsif boxes[point]
              if boxes[point] == point
                output << "["
              else
                output << "]"
              end
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
    end
  end
end
