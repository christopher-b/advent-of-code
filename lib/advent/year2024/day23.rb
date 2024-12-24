# https://adventofcode.com/2024/day/23
module Advent
  module Year2024
    class Day23 < Advent::Challenge
      # One of the fastest solves for this year. I'm liking learning about graph theory and some of the terminology.

      def part1
        triangles.size
      end

      def part2
        maximal_connected_subgraph.join(",")
      end

      def maximal_connected_subgraph
        max_clique = Set.new

        graph.nodes.each do |start|
          # Start with the node and its neighbors
          potential_clique = Set[start]
          candidates = graph.neighbors(start)

          until candidates.empty?
            neighbor = candidates.first

            # Check if this node is connected to all nodes in our current clique
            is_connected_to_all = potential_clique.all? do |clique_node|
              graph.neighbors(neighbor).include?(clique_node)
            end

            if is_connected_to_all
              potential_clique.add(neighbor)
              # Update candidates to only include nodes connected to all current clique members
              candidates.select! do |candidate|
                potential_clique.all? { |clique_node| graph.neighbors(candidate).include? clique_node }
              end
            end

            candidates.delete(neighbor)
          end

          max_clique = potential_clique if potential_clique.size > max_clique.size
        end

        max_clique.sort
      end

      def triangles
        @triangles ||= Set.new.tap do |tris|
          graph.nodes.each do |node|
            graph.neighbors(node).combination(2).each do |n1, n2|
              if graph.neighbors(n1).include?(n2)
                next unless node.start_with?("t") || n1.start_with?("t") || n2.start_with?("t")
                tris << [node, n1, n2].sort
              end
            end
          end
        end
      end

      def graph
        @graph ||= Advent::Graph.new(directed: false).tap do |g|
          each_line do |line|
            nodes = line.chomp.split "-"
            g.add_node(nodes[0])
            g.add_node(nodes[1])
            g.add_edge(nodes[0], nodes[1])
          end
        end
      end
    end
  end
end
