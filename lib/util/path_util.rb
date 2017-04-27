# Utility functions for path manipulation
module PathUtil
  # Returns array of vertices on shortest path from start to destination
  def self.path_array(paths, start, destination)
    path = []
    curr_vertex = destination
    loop do
      path.push(curr_vertex)
      return path.reverse if curr_vertex == start
      curr_vertex = paths[curr_vertex]
      return [] if curr_vertex.nil?
    end
  end
end
