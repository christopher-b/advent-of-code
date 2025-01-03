# https://adventofcode.com/2023/day/19
require "json"

module Advent
  module Year2023
    class Day19 < Advent::Challenge
      # Explanation here

      def part1
        accepted = []
        rejected = []
        inlet = Workflow.workflows["in"]
        @parts.each do |part|
          if inlet.process(part)
            accepted << part
          else
            rejected << part
          end
        end

        accepted.map { |p| p.x + p.m + p.a + p.s }.sum
      end

      def part2
      end

      def parse_input
        workflows, parts = input_text.split "\n\n"
        workflows.split("\n")
          .map { Workflow.new _1 }
          .each { Workflow.add_workflow(_1) }

        @parts = parts.split("\n").map { Part.new _1 }
      end

      class Workflow
        attr_reader :label
        @workflows = {}

        def initialize(init)
          chunks = init.split(/[,{}]/)
          @label = chunks.first
          @rules = chunks[1..].map { Rule.new(_1) }
        end

        def process(part)
          result = nil
          @rules.each do |rule|
            # We should get either a new Workflow, A/R, or nil
            case (result = rule.process(part))
            when "A"
              result = true
              break
            when "R"
              result = false
              break
              # return false
            when nil
              next
            else
              wf = self.class.workflows[result]
              result = wf.process(part)
              break
            end
          end
          result
        end

        def self.add_workflow(wf)
          @workflows[wf.label] = wf
        end

        def self.workflows
          @workflows
        end
      end

      class Rule
        def initialize(init)
          chunks = init.match(/(\w)([<>])(\d+):(\w+)/)
          if chunks
            @full_rule, @cat, @op, @limit, @dest = chunks.to_a
            @limit = @limit.to_i
          else
            @dest = init
          end
        end

        def process(part)
          return @dest unless @cat

          # Commented out because eval is evil (according to standardrb)
          code = "part.#{@cat} #{@op} #{@limit}"
          result = eval(code)

          @dest if result
        end
      end

      Part = Struct.new(:x, :m, :a, :s) do
        def initialize(init)
          attrs = init.match(/{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}/)
          super(x: attrs[1].to_i, m: attrs[2].to_i, a: attrs[3].to_i, s: attrs[4].to_i)
        end
      end
    end
  end
end
