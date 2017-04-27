# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dijkstra_graph/version'

Gem::Specification.new do |spec|
  spec.name          = 'dijkstra_graph'
  spec.version       = DijkstraGraph::VERSION
  spec.authors       = ['Mark Sayson']
  spec.email         = ['masayson@gmail.com']

  spec.summary       = "A graph implementation supporting Dijkstra's " \
                       'shortest path algorithm'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/msayson/dijkstra_graph'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host' to allow pushing to
  # a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'PriorityQueue', '~> 0.1'
  spec.add_dependency 'weighted_graph', '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  # Pry is a useful debugging utility, uncomment for local use.
  #
  # To use pry:
  # - Uncomment the 'spec.add_development_dependency' line below
  # - Add "require 'pry'" to the relevant Ruby source file
  # - Add 'binding.pry' above the line you wish to break at
  # - Run 'rake spec', and the console will break at that line
  # spec.add_development_dependency 'pry', '~> 0.10'
end
