require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PitchClassSet do
  context '.new' do
    context 'nothing given' do
      it 'should not raise an error' do
        lambda { PitchClassSet.new([]) }.should_not raise_error
      end
    end

    context 'pitch classes (Fixnum) given' do
      it 'should use the given pitch class' do
        10.times do
          pitch_classes = Array.new(rand(0..10)) { rand(0..8) }
          pcs = PitchClassSet.new pitch_classes
          pitch_classes.each do |pitch_class|
            pcs.include? pitch_class
          end
        end
      end
    end
    
    context 'Pitch objects given' do
      it 'should use the pitch semitone to determine pitch class' do
        10.times do
          pitches = Array.new(rand(0..10)) {
            Pitch.new(:octave => rand(0..8), :semitone => rand(0..8))
          }
          
          pcs = PitchClassSet.new pitches
          
          pitches.each do |pitch|
            pcs.include? pitch.semitone
          end
        end
      end
    end
    
    context 'Pitch objects and pitch classes (Fixnum) given' do
      it 'should use the pitch semitone to determine pitch class' do
        10.times do
          pitches = Array.new(rand(0..10)) {
            Pitch.new(:octave => rand(0..8), :semitone => rand(0..8))
          }
          pitch_classes = Array.new(rand(0..10)) { rand(0..8) }
          
          pcs = PitchClassSet.new pitches + pitch_classes
          
          pitches.each do |pitch|
            pcs.include? pitch.semitone
          end
          pitch_classes.each do |pitch_class|
            pcs.include? pitch_class
          end
        end
      end
    end

  end
  
  context '.add' do
    it 'should accept a Pitch object, and convert it to a pitch class' do
      pcs = PitchClassSet.new
      pcs.add Pitch.new(:semitone => 11)
      pcs.include?(11).should be_true
    end

    it 'should accept a Fixnum object' do
      pcs = PitchClassSet.new
      pcs.add 7
      pcs.include?(7).should be_true
    end
    
    it 'should raise ArgumentError for non-Pitch or non-Fixnum objects' do
      pcs = PitchClassSet.new
      cases = [ "okay", 6.54, [456] ]
      cases.each do |item|
        lambda { pcs.add item }.should raise_error(ArgumentError)
      end
    end
  end
end
