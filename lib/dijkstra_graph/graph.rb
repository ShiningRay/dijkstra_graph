require 'priority_queue'
require 'weighted_graph'

# Dijstra graph library
module DijkstraGraph
  # A graph supporting Dijkstra's shortest path algorithm
  #
  # Vertices are stored in a priority queue that supports
  # amortized O(1) updates to priority, which represents
  # distance from the start vertex.
  #
  # Edges are stored in an adjacency list for O(1) access
  # to the neighbours list of a given vertex.
  class Graph < WeightedGraph::Graph
    # Initialize graph vertices and edges
    def initialize
      super(Hash.new(0)) # Initializes edges adjacency list
      @vertices = PriorityQueue.new # Initialize vertices
    end

    # Add directed edge (source, destination) to the graph with given weight
    # Requires that weight is a positive number
    def add_edge(source, destination, weight)
      super(source, destination, weight) if weight > 0
    end

    # Add undirected edge (vertex_a, vertex_b) to the graph with given weight
    # Requires that weight is a positive number
    def add_undirected_edge(vertex_a, vertex_b, weight)
      super(vertex_a, vertex_b, weight) if weight > 0
    end
  end
end
