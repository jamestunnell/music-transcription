require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pitch do
  describe '#to_s' do
    context 'on-letter semitones' do
      it 'should return the semitone letter + octave number' do
        { C0 => "C0", D1 => "D1", E7 => "E7",
          F8 => "F8", G3 => "G3", A4 => "A4",
          B5 => "B5", C2 => "C2" }.each do |p,s|
          p.to_s.should eq s
        end
      end
    end
    
    context 'off-letter semitones' do
      context 'sharpit set false' do
        it 'should return semitone letter + "b" + octave number' do
          { Db0 => "Db0", Eb1 => "Eb1", Gb7 => "Gb7",
            Ab4 => "Ab4", Bb1 => "Bb1" }.each do |p,s|
            p.to_s(false).should eq s
          end
        end
      end
      
      context 'sharpit set true' do
        it 'should return semitone letter + "#" + octave number' do
          { Db0 => "C#0", Eb1 => "D#1", Gb7 => "F#7",
            Ab4 => "G#4", Bb1 => "A#1" }.each do |p,s|
            p.to_s(true).should eq s
          end          
        end
      end
    end
  end
end