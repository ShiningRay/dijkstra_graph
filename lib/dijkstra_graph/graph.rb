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
        v, distances[v] = queue.delete_min     # Visit next closest vertex
        next_neighbours(v, distances).each do |w| # Update neighbours
          queue[w] = distances[w] = updated_distance_to_w(v, w, distances)
        end
      end
      distances
    end

    # Use Dijkstra's algorithm to find the shortest paths
    # from the start vertex to each of the other vertices
    def shortest_paths(start)
      paths = {}                               # Initialize paths to empty hash
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(start)          # Initialize queue with start
      until queue.empty?
        v, distances[v] = queue.delete_min        # Visit next closest vertex
        next_neighbours(v, distances).each do |w| # Update neighbours
          update_path_to_w(v, w, paths, distances, queue)
        end
      end
      paths
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

    # If we find a shorter path to w, update w's path
    # and add w to the to-visit queue
    def update_path_to_w(v, w, paths, distances, queue)
      distance_through_v = distances[v] + get_edge_weight(v, w)
      return if distances[w] <= distance_through_v
      queue[w] = distances[w] = distance_through_v
      paths[w] = v
    end

    # Returns minimum distance to w found so far
    def updated_distance_to_w(v, w, distances)
      min(
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
