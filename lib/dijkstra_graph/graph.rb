# frozen_string_literal: true

require 'fc'
require 'weighted_graph'
require 'pry'
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
  # decrease_priority, and amortized O(log n) pop.
  # Priority represents path distance from the source vertex.
  #
  # The shortest distances found so far to each vertex are
  # stored in a simple hash which gives O(1) read/write.
  class Graph < WeightedGraph::PositiveWeightedGraph
    # Initialize graph edges
    def initialize
      super
    end

    # Use Dijkstra's algorithm to find the shortest distances
    # from the source vertex to each of the other vertices
    #
    # Returns a hash of form { 'source' => 0, 'a' => 3, 'b' => 4 },
    # where result[v] indicates the shortest distance from source to v
    def shortest_distances(source)
      distances = Hash.new { Float::INFINITY } # Initial distances = Inf
      queue = initialize_queue(source)         # Begin at source node
      # binding.pry
      until queue.empty?
        d = queue.top_key
        v = queue.pop # Visit next closest vertex

        distances[v] = d unless distances[v] < d

        update_distances_to_neighbours(v, distances, queue) # Update neighbours
      end
      distances
    end

    # Use Dijkstra's algorithm to find the shortest paths
    # from the source vertex to each of the other vertices
    #
    # Returns a hash of form { 'c' => ['a', 'b', 'c'] }, where
    # result[v] indicates the shortest path from source to v
    def shortest_paths(source)
      predecessors = {}                        # Initialize vertex predecessors
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(source)         # Initialize queue with source
      until queue.empty?
        # Visit next closest vertex and update neighbours
        d = queue.top_key
        v = queue.pop
        distances[v] = d
        update_paths_to_neighbours(v, distances, queue, predecessors)
      end
      PathUtil.path_arrays(predecessors, source)
    end

    # Use Dijkstra's algorithm to find the shortest paths
    # from the source vertex to vertices within a given radius
    #
    # Returns a hash of form { 'c' => ['a', 'b', 'c'] }, where
    # result[v] indicates the shortest path from source to v
    def shortest_paths_in_radius(source, radius)
      predecessors = {}                        # Initialize vertex predecessors
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(source)         # Initialize queue with source
      until queue.empty?
        # Visit next closest vertex and update neighbours
        distance = queue.top_key
        v = queue.pop
        return PathUtil.path_arrays(predecessors, source) if distance > radius

        distances[v] = distance
        update_neighbours_in_radius(v, distances, queue, predecessors, radius)
      end
      PathUtil.path_arrays(predecessors, source)
    end

    # Use Dijkstra's algorithm to find the shortest path
    # from the source vertex to the destination vertex
    #
    # Returns an array of vertices along the shortest path
    # of form ['a', 'b', 'c'], or [] if no such path exists
    def shortest_path(source, dest)
      predecessors = {}                        # Initialize vertex predecessors
      distances = Hash.new { Float::INFINITY } # Initialize distances to Inf
      queue = initialize_queue(source)         # Initialize queue with source
      until queue.empty?
        d = queue.top_key
        v = queue.pop # Visit next closest node
        distances[v] = d
        return PathUtil.path_array(predecessors, source, dest) if v == dest

        update_paths_to_neighbours(v, distances, queue, predecessors)
      end
      [] # No path found from source to dest
    end

    private

    # Initialize priority queue with source vertex at distance = 0
    def initialize_queue(source_vertex)
      queue = FastContainers::PriorityQueue.new(:min)
      queue.push(source_vertex, 0)
      queue
    end

    # Update distances to neighbours of v and queue changed neighbours
    def update_distances_to_neighbours(v, distances, queue)
      update_neighbours(v, distances, method(:update_distance),
                        distances: distances, queue: queue)
    end

    # Update paths to neighbours of v and queue changed neighbours
    def update_paths_to_neighbours(v, distances, queue, predecessors)
      update_neighbours(v, distances, method(:update_path),
                        distances: distances, queue: queue,
                        predecessors: predecessors, predecessor: v)
    end

    # Update paths to neighbours of v in radius and queue changed neighbours
    def update_neighbours_in_radius(v, distances, queue, predecessors, radius)
      update_neighbours(v, distances, method(:update_path),
                        distances: distances, queue: queue, radius: radius,
                        predecessors: predecessors, predecessor: v)
    end

    # Apply given method to each neighbour we find a shorter path to
    def update_neighbours(v, distances, update_method, update_params)
      distance_v = distances[v]
      get_adjacent_vertices(v).each do |w|
        distance_through_v = distance_v + get_edge_weight(v, w)
        if distance_through_v < distances[w]
          update_method.call(w, distance_through_v, update_params)
        end
      end
    end

    # Update shortest distance to vertex
    def update_distance(vertex, distance, params)
      params[:distances][vertex] = distance
      params[:queue].push(vertex, distance)
    end

    # Update shortest path to vertex
    def update_path(vertex, distance, params)
      return if params[:radius] && distance > params[:radius]

      update_distance(vertex, distance, params)
      params[:predecessors][vertex] = params[:predecessor]
    end
  end
end
