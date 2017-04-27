require 'spec_helper'

# PathUtil tests
module PathUtil
  describe PathUtil do
    describe '.path_array' do
      it "returns [] if start or destination don't exist" do
        expect(PathUtil.path_array({ 'a' => 'b' }, 'a', 'c')).to eq([])
        expect(PathUtil.path_array({ 'a' => 'b' }, 'd', 'b')).to eq([])
        expect(PathUtil.path_array({ 'a' => 'b' }, 'c', 'd')).to eq([])
      end

      it 'returns [] if no path from start to destination' do
        paths = { 'src' => 'a', 'dst' => 'b', 'b' => 'a' }
        expect(PathUtil.path_array(paths, 'src', 'dst')).to eq([])
      end

      it 'returns available path from start to destination' do
        paths = { 'd' => 'c', 'c' => 'b', 'b' => 'a' }
        expect(PathUtil.path_array(paths, 'a', 'd')).to eq(%w[a b c d])
      end
    end
  end
end
