require 'priority_queue'
require 'weighted_graph'

# Dijstra graph library
module DijkstraGraph
  # A graph supporting Dijkstra's shortest path algorithm
  #
  # Edges are stored in an adjacency list for O(1) access
  # to the neighbours list of a given vertex.
  #
  # Vertices 'to-visit' are stored in a priority queue that
  # uses a Fibonacci heap to give O(1) insert, amortized O(1)
  # decrease_priority, and amortized O(log n) delete_min.
  # Priority represents path distance from the start vertex.
  #
  # The shortest distances found so far to each vertex are
  # stored in a simple hash which gives O(1) read/write.
  class Graph < WeightedGraph::PositiveWeightedGraph
    # Initialize graph edges
    def initialize
      super
    end

    # Use Dijkstra's algorithm to find the shortest distances
    # from the start vertex to each of the other vertices
    def shortest_distances(start)
      distances = Hash.new { Float::INFINITY } # Initial distances = Inf
      queue = initialize_queue(start)          # Begin at start node
      until queue.empty?
        v, distances[v] = queue.delete_min     # Set distance to closest vertex
        next_neighbours(v, distances).each do |w| # Update neighbours
          update_distance_to_w(v, w, distances)
          queue[w] = distances[w]
        end
      end
      distances
    end

    private

    # Initialize priority queue with start vertex at distance = 0
    def initialize_queue(start_vertex)
      queue = PriorityQueue.new
      queue[start_vertex] = 0
      queue
    end

    # Returns adjacent vertices along outgoing edges from v
    # where known distance to neighbour > distance to v
    def next_neighbours(v, distances)
      distance_to_v = distances[v]
      get_adjacent_vertices(v).select { |w| distance_to_v < distances[w] }
    end

    # Update distance to w if path with edge (v,w) is shorter
    def update_distance_to_w(v, w, distances)
      distances[w] = min(
        distances[w],
        distances[v] + get_edge_weight(v, w)
      )
    end

    # Return the minimum of two values
    def min(a, b)
      a < b ? a : b
    end
  end
end
