module Advent
  # A graph data structure supporting both directed and undirected graphs.
  # Implements common graph algorithms including BFS pathfinding and Dijkstra's algorithm.
  #
  # @example Creating a directed graph
  #   graph = Graph.new(directed: true)
  #   graph.add_node("A")
  #   graph.add_node("B")
  #   graph.add_edge("A", "B", 5)
  #
  # @example Creating an undirected graph
  #   graph = Graph.new(directed: false)
  #   graph.add_edge("A", "B", 3)  # Creates edges in both directions
  #   graph.neighbors("B")  # => ["A"]
  class Graph
    # @return [Hash] The adjacency list representation of the graph
    #   Keys are nodes, values are hashes of {neighbor => weight}
    attr_accessor :adjacency_list

    # Creates a new Graph.
    #
    # @param directed [Boolean] Whether the graph is directed (default: true)
    def initialize(directed: true)
      @directed = directed
      @adjacency_list = {}
    end

    # Returns all nodes in the graph.
    #
    # @return [Array] Array of node values
    def nodes
      @adjacency_list.keys
    end

    # Adds a node to the graph.
    # If the node already exists, this is a no-op.
    #
    # @param value [Object] The node value to add
    # @return [Hash] The node's neighbor hash (empty if newly created)
    def add_node(value)
      @adjacency_list[value] ||= {}
    end

    # Adds an edge between two nodes.
    # For undirected graphs, creates edges in both directions.
    # Nodes are automatically created if they don't exist.
    #
    # @param node1 [Object] The first node
    # @param node2 [Object] The second node
    # @param weight [Numeric] The edge weight (default: 1)
    # @return [Numeric] The weight that was set
    def add_edge(node1, node2, weight = 1)
      @adjacency_list[node1][node2] = weight
      @adjacency_list[node2][node1] = weight unless @directed
    end

    # Returns the neighbors of a node.
    #
    # @param node [Object] The node to get neighbors for
    # @return [Array] Array of neighbor node values
    def neighbors(node)
      @adjacency_list[node].keys
    end

    # Returns the weight of an edge between two nodes.
    #
    # @param node1 [Object] The first node
    # @param node2 [Object] The second node
    # @return [Numeric, nil] The edge weight, or nil if no edge exists
    def edge_weight(node1, node2)
      @adjacency_list[node1][node2]
    end

    # Finds a path between two nodes using breadth-first search.
    # Returns the shortest path in terms of number of edges (unweighted).
    #
    # @param start_node [Object] The starting node
    # @param end_node [Object] The destination node
    # @return [Array, nil] Array of nodes representing the path, or nil if no path exists
    # @example
    #   graph.bfs_paths("A", "D")  # => ["A", "B", "D"]
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

    # Finds the shortest path between two nodes using Dijkstra's algorithm.
    # Takes edge weights into account to find the minimum-weight path.
    #
    # @param start_node [Object] The starting node
    # @param end_node [Object] The destination node
    # @return [Hash, nil] Hash with :distance and :path keys, or nil if nodes don't exist
    # @example
    #   result = graph.dijsktra_path("A", "D")
    #   result[:distance]  # => 7
    #   result[:path]      # => ["A", "B", "D"]
    def dijsktra_path(start_node, end_node)
      # Validate nodes exist
      return nil unless @adjacency_list.key?(start_node) && @adjacency_list.key?(end_node)

      # Initialize distances and previous nodes
      distances = {}
      previous = {}
      unvisited = {}

      # Set all distances to infinity except start node
      @adjacency_list.keys.each do |node|
        distances[node] = (node == start_node) ? 0 : Float::INFINITY
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

    # Reconstructs a path from Dijkstra's algorithm results.
    # Traces backwards from the end node using the previous node map.
    #
    # @param previous [Hash] Map of node => previous node in shortest path
    # @param start_node [Object] The starting node
    # @param end_node [Object] The ending node
    # @return [Array] The path from start_node to end_node
    # @api private
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
