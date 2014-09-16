require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Tempo do
  describe '#==' do
    context 'same bpm and beat duration' do
      it 'should return true' do
        [
          [120,nil],
          [120,0.25.to_r],
          [300,"3/8".to_r]
        ].each do |bpm,bd|
          Tempo.new(bpm,bd).should eq(Tempo.new(bpm,bd))
        end
      end
    end
    
    context 'different bpm or beat duration' do
      it 'should return false' do
        Tempo.new(120,nil).should_not eq(Tempo.new(120,"1/4".to_r))
        Tempo.new(200,2).should_not eq(Tempo.new(200,2.1))
      end
    end
  end
end
