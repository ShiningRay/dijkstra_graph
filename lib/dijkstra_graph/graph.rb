require 'priority_queue'
require 'weighted_graph'

require_relative '../util/path_util'

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
    #
    # Returns a hash of form { 'start' => 0, 'a' => 3, 'b' => 4 },
    # where result[v] indicates the shortest distance from start to v
    def shortest_distances(start)
      distances = Hash.new { Float::INFINITY } # Initial distances = Inf
      queue = initialize_queue(start)          # Begin at start node
      until queue.empty?
        v, distances[v] = queue.delete_min     # Visit next closest vertex
        update_distances_to_neighbours(v, distances, queue) # Update neighbours
      end
      distances
    end

    # Use Dijkstra's algorithm to find the shortest paths
    # from the start vertex to each of the other vertices
    #
    # Returns a hash of form { 'c' => ['a', 'b', 'c'] }, where
    # result[v] indicates the shortest path from start to v
    def shortest_paths(start)
      predecessors = {}                        # Initialize vertex predecessors
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(start)          # Initialize queue with start
      until queue.empty?
        # Visit next closest vertex and update neighbours
        v, distances[v] = queue.delete_min
        update_paths_to_neighbours(v, predecessors, distances, queue)
      end
      PathUtil.path_arrays(predecessors, start)
    end

    # Use Dijkstra's algorithm to find the shortest path
    # from the start vertex to the destination vertex
    #
    # Returns an array of vertices along the shortest path
    # of form ['a', 'b', 'c'], or [] if no such path exists
    def shortest_path(start, dest)
      predecessors = {}                        # Initialize vertex predecessors
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(start)          # Initialize queue with start
      until queue.empty?
        v, distances[v] = queue.delete_min     # Visit next closest node
        return PathUtil.path_array(predecessors, start, dest) if v == dest
        update_paths_to_neighbours(v, predecessors, distances, queue)
      end
      [] # No path found from start to dest
    end

    private

    # Initialize priority queue with start vertex at distance = 0
    def initialize_queue(start_vertex)
      queue = PriorityQueue.new
      queue[start_vertex] = 0
      queue
    end

    # Update distances to neighbours of v and queue changed neighbours
    def update_distances_to_neighbours(v, distances, queue)
      distance_v = distances[v]
      get_adjacent_vertices(v).each do |w|
        distance_through_v = distance_v + get_edge_weight(v, w)
        if distance_through_v < distances[w]
          queue[w] = distances[w] = distance_through_v
        end
      end
    end

    # Update paths to neighbours of v and queue changed neighbours
    def update_paths_to_neighbours(v, predecessors, distances, queue)
      distance_v = distances[v]
      get_adjacent_vertices(v).each do |w|
        distance_through_v = distance_v + get_edge_weight(v, w)
        if distance_through_v < distances[w]
          queue[w] = distances[w] = distance_through_v
          predecessors[w] = v
        end
      end
    end
  end
end
