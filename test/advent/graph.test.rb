Graph = Advent::Grid

test "connected nodes linear chain" do
  # A -> B -> C -> D
  graph = Advent::Graph.new(directed: true)
  graph.add_edge("A", "B")
  graph.add_edge("B", "C")
  graph.add_edge("C", "D")

  result = graph.connected_nodes("A")
  assert_equal Set["B", "C", "D"], result
end

test "connected nodes max depth" do
  # A -> B -> C -> D
  graph = Advent::Graph.new(directed: true)
  graph.add_edge("A", "B")
  graph.add_edge("B", "C")
  graph.add_edge("C", "D")
  graph.add_edge("A", "E")

  result = graph.connected_nodes("A", max_depth: 1)
  assert_equal Set["B", "E"], result
end

test "connected nodes complex graph" do
  # A -> B -> D -> F
  #   -> C -> E -> F
  graph = Advent::Graph.new(directed: true)
  graph.add_edge("A", "B")
  graph.add_edge("A", "C")
  graph.add_edge("B", "D")
  graph.add_edge("C", "E")
  graph.add_edge("D", "F")
  graph.add_edge("E", "F")

  result = graph.connected_nodes("A")
  assert_equal Set["B", "C", "D", "E", "F"], result
end

test "connected nodes undirected" do
  # A -- B -- C
  graph = Advent::Graph.new(directed: false)
  graph.add_edge("A", "B")
  graph.add_edge("B", "C")

  result = graph.connected_nodes("A")
  assert_equal Set["B", "C"], result

  result = graph.connected_nodes("B")
  assert_equal Set["A", "C"], result
end
