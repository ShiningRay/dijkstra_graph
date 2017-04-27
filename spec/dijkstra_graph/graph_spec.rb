require 'spec_helper'

# Dijkstra Graph API tests
module DijkstraGraph
  describe Graph do
    it { is_expected.to respond_to(:shortest_distances).with(1).argument }

    before do
      @graph = DijkstraGraph::Graph.new
    end

    describe '.shortest_distances' do
      it 'behaves nicely for empty graphs' do
        dists_from_a = @graph.shortest_distances('a')
        # We just return a zero distance from the given
        # start vertex to itself.
        expect(dists_from_a).to eq('a' => 0)
      end
      it 'uses direct path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 5)
        @graph.add_edge('b', 'c', 10)
        dists_from_a = @graph.shortest_distances('a')
        expect(dists_from_a['b']).to eq(3)
        expect(dists_from_a['c']).to eq(5)
      end
      it 'uses indirect path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 50)
        @graph.add_edge('b', 'c', 10)
        dists_from_a = @graph.shortest_distances('a')
        expect(dists_from_a['c']).to eq(13)
      end
      it 'finds shortest paths to all connected vertices' do
        @graph.add_edge('a', 'b', 5)
        @graph.add_edge('b', 'a', 4)
        @graph.add_edge('b', 'c', 2)
        @graph.add_edge('c', 'd', 8)
        @graph.add_undirected_edge('d', 'e', 5)
        @graph.add_edge('a', 'f', 10)
        @graph.add_edge('f', 'e', 12)
        @graph.add_edge('start', 'b', 3)
        @graph.add_edge('start', 'c', 4)
        @graph.add_edge('unconnected1', 'unconnected2', 2)
        dists_from_start = @graph.shortest_distances('start')
        expect(dists_from_start['start']).to eq(0)
        expect(dists_from_start['a']).to eq(7)
        expect(dists_from_start['b']).to eq(3)
        expect(dists_from_start['c']).to eq(4)
        expect(dists_from_start['d']).to eq(12)
        expect(dists_from_start['e']).to eq(17)
        expect(dists_from_start['f']).to eq(17)
        expect(dists_from_start['unconnected1']).to eq(Float::INFINITY)
        expect(dists_from_start['unconnected2']).to eq(Float::INFINITY)
      end
    end
  end
end
