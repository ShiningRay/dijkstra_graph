require 'spec_helper'

# Dijkstra Graph API tests
module DijkstraGraph
  describe Graph do
    it { is_expected.to respond_to(:shortest_distances).with(1).argument }
    it { is_expected.to respond_to(:shortest_paths).with(1).argument }
    it { is_expected.to respond_to(:shortest_paths_in_radius).with(2).arguments }
    it { is_expected.to respond_to(:shortest_path).with(2).arguments }

    before do
      @graph = DijkstraGraph::Graph.new
    end

    describe '.shortest_distances' do
      it 'contains zero for start node' do
        dists_from_a = @graph.shortest_distances('a')
        expect(dists_from_a).to eq('a' => 0)
      end
      it 'contains distance along direct path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 5)
        @graph.add_edge('b', 'c', 10)
        dists_from_a = @graph.shortest_distances('a')
        expect(dists_from_a['b']).to eq(3)
        expect(dists_from_a['c']).to eq(5)
      end
      it 'contains distance along indirect path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 50)
        @graph.add_edge('b', 'c', 10)
        dists_from_a = @graph.shortest_distances('a')
        expect(dists_from_a['c']).to eq(13)
      end
      it 'contains shortest distances to all connected vertices' do
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

    describe '.shortest_paths' do
      it 'returns an empty hash for empty graphs' do
        expect(@graph.shortest_paths('a')).to be_empty
      end
      it 'returns an empty hash for non-existent start vertices' do
        @graph.add_edge('a', 'b', 3)
        expect(@graph.shortest_paths('c')).to be_empty
      end
      it 'returns hash with direct path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 5)
        @graph.add_edge('b', 'c', 10)
        paths_from_a = @graph.shortest_paths('a')
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['c']).to eq(%w[a c])
      end
      it 'returns hash with indirect path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 50)
        @graph.add_edge('b', 'c', 10)
        paths_from_a = @graph.shortest_paths('a')
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['c']).to eq(%w[a b c])
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
        paths_from_start = @graph.shortest_paths('start')
        expect(paths_from_start['start']).to eq([])
        expect(paths_from_start['a']).to eq(%w[start b a])
        expect(paths_from_start['b']).to eq(%w[start b])
        expect(paths_from_start['c']).to eq(%w[start c])
        expect(paths_from_start['d']).to eq(%w[start c d])
        expect(paths_from_start['e']).to eq(%w[start c d e])
        expect(paths_from_start['f']).to eq(%w[start b a f])
        expect(paths_from_start['unconnected1']).to eq([])
        expect(paths_from_start['unconnected2']).to eq([])
      end
    end

    describe '.shortest_paths_in_radius' do
      it 'returns an empty hash for empty graphs' do
        expect(@graph.shortest_paths_in_radius('a', 5)).to be_empty
      end
      it 'returns an empty hash for non-existent start vertices' do
        @graph.add_edge('a', 'b', 3)
        expect(@graph.shortest_paths_in_radius('c', 5)).to be_empty
      end
      it 'returns an empty hash when no edges are in radius' do
        @graph.add_edge('a', 'b', 3)
        expect(@graph.shortest_paths_in_radius('c', 2)).to be_empty
      end
      it 'returns hash with direct path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 5)
        @graph.add_edge('b', 'c', 10)
        paths_from_a = @graph.shortest_paths_in_radius('a', 100)
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['c']).to eq(%w[a c])
      end
      it 'returns hash with indirect path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 50)
        @graph.add_edge('b', 'c', 10)
        paths_from_a = @graph.shortest_paths_in_radius('a', 100)
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['c']).to eq(%w[a b c])
      end
      it 'returns hash only containing paths in radius' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 10)
        @graph.add_edge('b', 'c', 8)
        @graph.add_edge('a', 'd', 4)
        @graph.add_edge('d', 'e', 4)
        paths_from_a = @graph.shortest_paths_in_radius('a', 8)
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['d']).to eq(%w[a d])
        expect(paths_from_a['e']).to eq(%w[a d e])
        expect(paths_from_a['c']).to eq([])
      end
    end

    describe '.shortest_path' do
      it 'returns an empty array for empty graphs' do
        expect(@graph.shortest_path('a', 'b')).to be_empty
      end
      it 'returns an empty array for non-existent vertices' do
        @graph.add_edge('a', 'b', 3)
        expect(@graph.shortest_path('a', 'c')).to be_empty
        expect(@graph.shortest_path('d', 'a')).to be_empty
        expect(@graph.shortest_path('c', 'd')).to be_empty
      end
      it 'returns an empty array if no path exists' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('b', 'c', 3)
        expect(@graph.shortest_path('c', 'a')).to be_empty
      end
      it 'returns [v] for shortest path from v to v' do
        expect(@graph.shortest_path('a', 'a')).to eq(['a'])
      end
      it 'returns direct path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 5)
        @graph.add_edge('b', 'c', 10)
        path = @graph.shortest_path('a', 'c')
        expect(path).to eq(%w[a c])
      end
      it 'returns indirect path if it is shorter' do
        @graph.add_edge('a', 'b', 3)
        @graph.add_edge('a', 'c', 50)
        @graph.add_edge('b', 'c', 10)
        path = @graph.shortest_path('a', 'c')
        expect(path).to eq(%w[a b c])
      end
      it 'returns shortest path from start to destination' do
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
        expect(@graph.shortest_path('start', 'a')).to eq(%w[start b a])
        expect(@graph.shortest_path('start', 'b')).to eq(%w[start b])
        expect(@graph.shortest_path('start', 'c')).to eq(%w[start c])
        expect(@graph.shortest_path('start', 'd')).to eq(%w[start c d])
        expect(@graph.shortest_path('start', 'e')).to eq(%w[start c d e])
        expect(@graph.shortest_path('start', 'f')).to eq(%w[start b a f])
        expect(@graph.shortest_path('start', 'unconnected1')).to eq([])
        expect(@graph.shortest_path('start', 'unconnected2')).to eq([])
      end
    end
  end
end
