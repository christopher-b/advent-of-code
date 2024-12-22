module Advent
  class Graph
    attr_accessor :adjacency_list

    def initialize
      @adjacency_list = {}
    end

    def nodes
      @adjacency_list.keys
    end

    def add_node(value)
      @adjacency_list[value] ||= {}
    end

    def add_edge(node1, node2, weight = 1)
      @adjacency_list[node1][node2] = weight
      # @adjacency_list[node2][node1] = weight  # For undirected graph
    end

    def edge_weight(node1, node2)
      @adjacency_list[node1][node2]
    end

    def bfs_paths(start_node, end_node)
      queue = [[start_node]]
      visited = Set.new [start_node]

      while queue.any?
        path = queue.shift
        node = path.last

        return path if node == end_node

        @adjacency_list[node].keys.each do |neighbor|
          next if visited.include?(neighbor)
          visited << neighbor
          queue << path + [neighbor]
        end
      end

      nil
    end

    def dijsktra_path(start_node, end_node)
      # Validate nodes exist
      return nil unless @adjacency_list.key?(start_node) && @adjacency_list.key?(end_node)

      # Initialize distances and previous nodes
      distances = {}
      previous = {}
      unvisited = {}

      # Set all distances to infinity except start node
      @adjacency_list.keys.each do |node|
        distances[node] = node == start_node ? 0 : Float::INFINITY
        unvisited[node] = true
      end

      while unvisited.any?
        # Find the unvisited node with the smallest distance
        current = unvisited.min_by { |node, _| distances[node] }[0]

        # If we've reached the end node, we're done
        break if current == end_node || distances[current] == Float::INFINITY

        # Mark current node as visited
        unvisited.delete(current)

        # Check all neighbors of current node
        @adjacency_list[current].each do |neighbor, weight|
          next unless unvisited[neighbor]

          # Calculate potential new distance
          potential_distance = distances[current] + weight

          # Update if we've found a shorter path
          if potential_distance < distances[neighbor]
            distances[neighbor] = potential_distance
            previous[neighbor] = current
          end
        end
      end

      # distances[end_node]
      # Reconstruct the path
      path = reconstruct_path(previous, start_node, end_node)

      {
        distance: distances[end_node],
        path: path
      }
    end

    private

    def reconstruct_path(previous, start_node, end_node)
      path = []
      current = end_node

      # Trace back from end node to start node
      while current
        path.unshift(current)
        current = previous[current]
        break if current == start_node
      end

      path.unshift(start_node) if current == start_node
      path
    end
  end
end
