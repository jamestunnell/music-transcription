require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Scale do
  describe '#pitch_at' do
    it 'should produce a pitch for any Fixnum' do
      scale = Scale.new(C, IntervalVectors::Heptatonic::Prima::IONIAN)
      [0,1,2,10,13,-10,48,-36].each do |scale_index|
        scale.pitch_at(scale_index).should be_a(Pitch)
      end
    end
    
    it 'should produce pitches that are along the scale' do
      cases = {
        Scale.new(C, IntervalVectors::Heptatonic::Prima::IONIAN) => {
          :octave => 2,
          :io_pairs => { 0 => C2, 1 => D2, 2 => E2, 7 => C3 }
        },
        Scale.new(E, IntervalVector.new([2,2,1,2])) => {
          :octave => 4,
          :io_pairs => { 0 => E4, 1 => Gb4, 2 => Ab4, 3 => A4, 4 => B4, 5 => Db5, -1 => D4, -2 => Db4 }
        },
      }.each do |scale, params|
        params[:io_pairs].each do |scale_idx, expected_pitch|
          scale.pitch_at(scale_idx, params[:octave]).should eq(expected_pitch)
        end
      end
    end
  end
end
