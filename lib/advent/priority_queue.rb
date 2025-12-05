# From https://www.brianstorti.com/implementing-a-priority-queue-in-ruby/
module Advent
  # A max-heap priority queue implementation.
  # Elements with higher values have higher priority and are popped first.
  #
  # @example Basic usage
  #   queue = PriorityQueue.new
  #   queue << 5
  #   queue << 10
  #   queue << 3
  #   queue.pop  # => 10
  #   queue.pop  # => 5
  #
  # @example Initialize with elements
  #   queue = PriorityQueue.new([3, 1, 4, 1, 5])
  #   queue.pop  # => 5
  #
  # @note This is a max-heap, so larger values are retrieved first.
  #   For min-heap behavior, negate values when inserting and when using them.
  class PriorityQueue
    # Creates a new PriorityQueue.
    #
    # @param elements [Array] Optional array of initial elements
    def initialize(elements = [])
      @elements = [nil]
      elements.each { |element| self << element }
    end

    # Checks if the queue is empty.
    #
    # @return [Boolean] True if the queue has no elements
    def empty?
      @elements.size == 1
    end

    # Adds an element to the queue.
    # The element is placed in the correct position to maintain heap property.
    #
    # @param element [Comparable] The element to add
    # @return [PriorityQueue] Self for chaining
    def <<(element)
      @elements << element
      bubble_up(@elements.size - 1)
    end

    # Removes and returns the highest priority element.
    # For a max-heap, this is the largest element.
    #
    # @return [Comparable, nil] The highest priority element, or nil if empty
    def pop
      # exchange the root with the last element
      exchange(1, @elements.size - 1)

      # remove the last element of the list
      max = @elements.pop

      # and make sure the tree is ordered again
      bubble_down(1)
      max
    end

    # Moves an element up the heap until the heap property is satisfied.
    # Called after inserting a new element.
    #
    # @param index [Integer] The index of the element to bubble up
    # @return [void]
    # @api private
    def bubble_up(index)
      parent_index = (index / 2)

      # return if we reach the root element
      return if index <= 1

      # or if the parent is already greater than the child
      return if @elements[parent_index] >= @elements[index]

      # otherwise we exchange the child with the parent
      exchange(index, parent_index)

      # and keep bubbling up
      bubble_up(parent_index)
    end

    # Moves an element down the heap until the heap property is satisfied.
    # Called after removing the root element.
    #
    # @param index [Integer] The index of the element to bubble down
    # @return [void]
    # @api private
    def bubble_down(index)
      child_index = (index * 2)

      # stop if we reach the bottom of the tree
      return if child_index > @elements.size - 1

      # make sure we get the largest child
      not_the_last_element = child_index < @elements.size - 1
      left_element = @elements[child_index]
      right_element = @elements[child_index + 1]
      child_index += 1 if not_the_last_element && right_element > left_element

      # there is no need to continue if the parent element is already bigger
      # then its children
      return if @elements[index] >= @elements[child_index]

      exchange(index, child_index)

      # repeat the process until we reach a point where the parent
      # is larger than its children
      bubble_down(child_index)
    end

    # Swaps two elements in the heap.
    #
    # @param source [Integer] The index of the first element
    # @param target [Integer] The index of the second element
    # @return [void]
    # @api private
    def exchange(source, target)
      @elements[source], @elements[target] = @elements[target], @elements[source]
    end
  end
end
