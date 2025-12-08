# Union-Find (Disjoint Set Union) data structure.
# Efficiently tracks and merges connected components using path compression.
#
# @example Basic usage
#   ds = DisjointSet.new
#   ds.make_set("A")
#   ds.make_set("B")
#   ds.make_set("C")
#   ds.union("A", "B")
#   ds.find_root("A")  # => "A"
#   ds.find_root("B")  # => "A"
#   ds.size("A")       # => 2
#   ds.num_components  # => 2
class DisjointSet
  # @return [Integer] The number of disjoint components in the structure
  attr_reader :num_components

  # Creates a new DisjointSet with no elements.
  def initialize
    @parent = {}
    @size = {}
    @num_components = 0
  end

  # Creates a new set containing only this element.
  # If the element already exists, this is a no-op.
  #
  # @param x [Object] The element to add
  # @return [void]
  def make_set(x)
    return if @parent.key?(x)

    @parent[x] = x
    @size[x] = 1
    @num_components += 1
  end

  # Finds the root of the set containing x.
  # Uses path compression to optimize future lookups.
  #
  # @param x [Object] The element to find the root for
  # @return [Object] The root element of the set containing x
  def find_root(x)
    @parent[x] = find_root(@parent[x]) if @parent[x] != x

    @parent[x]
  end

  # Merges the sets containing x and y.
  # If x and y are already in the same set, this is a no-op.
  #
  # @param x [Object] The first element
  # @param y [Object] The second element
  # @return [void]
  def union(x, y)
    root_x = find_root(x)
    root_y = find_root(y)

    return if root_x == root_y

    # Simple union: attach root_y under root_x
    @parent[root_y] = root_x
    @size[root_x] += @size.delete root_y

    # We merged two components into one
    @num_components -= 1
  end

  # Check if x and y are in the same set
  # def connected?(x, y)
  #   find_root(x) == find_root(y)
  # end

  # Returns the size of the component containing x.
  #
  # @param x [Object] The element to check
  # @return [Integer] The number of elements in the component containing x
  def size(x)
    @size[find_root(x)]
  end

  # Returns the sizes of all components.
  #
  # @return [Array<Integer>] Array of component sizes
  def component_sizes
    # Find all unique roots and return their sizes
    roots = @parent.keys.map { |x| find_root(x) }.uniq
    roots.map { |root| @size[root] }
  end
end
