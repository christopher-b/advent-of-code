# Coding Guidelines for Advent of Code Solutions

## Build/Test Commands
- Run all tests: `mise run test` or `bin/qt`
- Run single test file: `bin/qt test/advent/year2024/day01.test.rb`
- Run tests in watch mode: `mise run watch` or `bin/guard`
- Lint code: `mise run lint` or `bundle exec standardrb`
- Auto-fix lint issues: `bundle exec standardrb --fix`

## Code Style
- Follow StandardRB style guide (enforced via `standard` gem)
- Use double quotes ("") for strings, never change quote style
- Use snake_case for methods and variables
- Use modules for namespacing (e.g., `Advent::Year2024::Day01`)
- Prefer `attr_reader` for read-only attributes
- Include descriptive comments for complex algorithms
- Use YARD-style documentation comments for public methods

## Challenge Implementation
- Inherit from `Advent::Challenge` for all day solutions
- Implement `part1` and `part2` methods for solutions
- Use `input_lines`, `input_text`, `input_chunks`, or `each_line` for input parsing
- Optional: implement `parse_input` for preprocessing (called before part1/part2)
- Memoize expensive computations with `@var ||=` pattern
- Use Struct for simple data objects (e.g., `Rotation = Struct.new(:dir, :delta)`)

## Error Handling
- Raise custom exceptions for domain-specific errors (e.g., `Grid::OutOfRangeError`)
- Use `raise` with descriptive messages for invalid states
