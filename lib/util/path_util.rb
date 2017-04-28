# Utility functions for path manipulation
module PathUtil
  # Returns hash mapping each vertex to the shortest path
  # from the start to that vertex
  def self.path_arrays(predecessors, start)
    paths = Hash.new { [] }
    start_has_outgoing_edges = false
    predecessors.each do |v, pred|
      start_has_outgoing_edges = true if pred == start
      paths[v] = path_array(predecessors, start, v)
    end
    start_has_outgoing_edges ? paths : {}
  end

  # Returns array of vertices on shortest path from start to destination
  def self.path_array(predecessors, start, destination)
    path = []
    curr_vertex = destination
    loop do
      path.push(curr_vertex)
      return path.reverse if curr_vertex == start
      curr_vertex = predecessors[curr_vertex]
      return [] if curr_vertex.nil?
    end
  end
end
