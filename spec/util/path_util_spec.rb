require 'spec_helper'

# PathUtil tests
module PathUtil
  describe PathUtil do
    it { is_expected.to respond_to(:path_array).with(3).arguments }
    it { is_expected.to respond_to(:path_arrays).with(2).arguments }

    describe '.path_array' do
      it "returns [] if start or destination don't exist" do
        expect(PathUtil.path_array({ 'a' => 'b' }, 'a', 'c')).to eq([])
        expect(PathUtil.path_array({ 'a' => 'b' }, 'd', 'b')).to eq([])
        expect(PathUtil.path_array({ 'a' => 'b' }, 'c', 'd')).to eq([])
      end

      it 'returns [] if no path from start to destination' do
        predecessors = { 'src' => 'a', 'dst' => 'b', 'b' => 'a' }
        expect(PathUtil.path_array(predecessors, 'src', 'dst')).to eq([])
      end

      it 'returns available path from start to destination' do
        predecessors = { 'd' => 'c', 'c' => 'b', 'b' => 'a' }
        expect(PathUtil.path_array(predecessors, 'a', 'd')).to eq(%w[a b c d])
      end
    end

    describe '.path_arrays' do
      it 'returns an empty hash if start has no outgoing edges' do
        expect(PathUtil.path_arrays({}, 'c')).to be_empty
        expect(PathUtil.path_arrays({ 'b' => 'a' }, 'c')).to eq({})
      end

      it 'returns hash with [] entries for vertices unreachable from start' do
        predecessors = { 'b' => 'a', 'd' => 'c' }
        paths_from_a = PathUtil.path_arrays(predecessors, 'a')
        expect(paths_from_a['c']).to eq([])
        expect(paths_from_a['d']).to eq([])
        expect(paths_from_a['unconnected']).to eq([])
      end

      it 'returns shortest path array for each vertex reachable from start' do
        predecessors = { 'b' => 'a', 'd' => 'a', 'e' => 'b' }
        paths_from_a = PathUtil.path_arrays(predecessors, 'a')
        expect(paths_from_a['b']).to eq(%w[a b])
        expect(paths_from_a['d']).to eq(%w[a d])
        expect(paths_from_a['e']).to eq(%w[a b e])
      end
    end
  end
end
