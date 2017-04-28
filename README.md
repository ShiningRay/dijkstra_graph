# dijkstra_graph

dijkstra_graph is a Ruby library implementing Dijkstra's shortest path algorithm.

It uses a Fibonnaci heap for amortized O(1) updates of vertex distances, and an adjacency list for edges for O(1) look-up of the neighbours list for the current vertex.

## DijkstraGraph::Graph API

```ruby
# Add directed edge (source, destination) to the graph with given weight
# Requires that weight is a positive number
add_edge(source, destination, weight)

# Add undirected edge (vertex_a, vertex_b) to the graph with given weight
# Requires that weight is a positive number
add_undirected_edge(vertex_a, vertex_b, weight)

# Remove directed edge (source, destination) from the graph
remove_edge(source, destination)

# Remove undirected edge (vertex_a, vertex_b) from the graph
remove_undirected_edge(vertex_a, vertex_b)

# Return true iff the graph contains directed edge (source, destination)
contains_edge?(source, destination)

# Returns the weight of directed edge (source, destination),
# or returns Float::INFINITY if no such edge exists
get_edge_weight(source, destination)

# Returns the set of vertices v_i where edge (source, v_i) is in the graph
get_adjacent_vertices(source)

# Use Dijkstra's algorithm to find the shortest distances
# from the source vertex to each of the other vertices
#
# Returns a hash of form { 'source' => 0, 'a' => 3, 'b' => 4 },
# where result[v] indicates the shortest distance from source to v
shortest_distances(source)

# Use Dijkstra's algorithm to find the shortest paths
# from the source vertex to each of the other vertices
#
# Returns a hash of form { 'c' => ['a', 'b', 'c'] }, where
# result[v] indicates the shortest path from source to v
shortest_paths(source)

# Use Dijkstra's algorithm to find the shortest paths
# from the source vertex to vertices within a given radius
#
# Returns a hash of form { 'c' => ['a', 'b', 'c'] }, where
# result[v] indicates the shortest path from source to v
shortest_paths_in_radius(source, radius)

# Use Dijkstra's algorithm to find the shortest path
# from the source vertex to the destination vertex
#
# Returns an array of vertices along the shortest path
# of form ['a', 'b', 'c'], or [] if no such path exists
shortest_path(source, destination)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dijkstra_graph'
```

Then you can require the gem in Ruby programs:

```ruby
require 'dijkstra_graph'

graph = DijkstraGraph::Graph.new
graph.add_undirected_edge('Burnaby', 'Vancouver', 10)
graph.add_edge('Burnaby', 'Port Coquitlam', 23)
graph.add_edge('Vancouver', 'Langley', 37)
graph.add_undirected_edge('Langley', 'Port Coquitlam', 35)
shortest_paths_from_vancouver = graph.shortest_paths('Vancouver')

# => { 'Burnaby' => ['Vancouver', 'Burnaby'],
#      'Langley' => ['Vancouver', 'Langley'],
#      'Port Coquitlam' => ['Vancouver', 'Burnaby', 'Port Coquitlam'] }

van_paths_within_35k = graph.shortest_paths_in_radius('Vancouver', 35)

# => { 'Burnaby' => ['Vancouver', 'Burnaby'],
#      'Port Coquitlam' => ['Vancouver', 'Burnaby', 'Port Coquitlam'] }

van_to_portco_path = graph.shortest_path('Vancouver', 'Port Coquitlam')

# => ['Vancouver', 'Burnaby', 'Port Coquitlam']

distances_from_vancouver = graph.shortest_distances('Vancouver')

# => { 'Vancouver' => 0, 'Burnaby' => 10,
#      'Langley' => 37, 'Port Coquitlam' => 33 }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msayson/dijkstra_graph.

## License

The dijkstra_graph library is open source and available under the terms of the [MIT License](http://opensource.org/licenses/MIT).
