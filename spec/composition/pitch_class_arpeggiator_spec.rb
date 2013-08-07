require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::PitchClassArpeggiator do
  describe '.new' do
    before :all do
      @good_pcs = [0,1,2]
      @bad_pcs = []
    end
    
    it 'should raise an ArgumentError if empty pitch class set is given' do
      ->(){ PitchClassArpeggiator.new(@bad_pcs) }.should raise_error
    end

    it 'should not raise an ArgumentError otherwise' do
      ->(){ PitchClassArpeggiator.new(@good_pcs) }.should_not raise_error
    end
  end

  before :all do
    @param_hashes = [
      { :pcs => [0,4,7], :rhythm => [0.25, 0.125, 0.5, 0.125], :octave => 4 },
      { :pcs => [1,3,1,6], :rhythm => [Rational(1,6), Rational(1,6), Rational(1,6)], :octave => 2 },
      { :pcs => [4,7,11,2], :rhythm => [Rational(1,4)], :octave => 1 },
      { :pcs => [0,6,2,0,4], :rhythm => [Rational(1,4), Rational(1,2)], :octave => 5 },
    ]

    @results = {}
    @param_hashes.each do |params|
      arpeggiator = PitchClassArpeggiator.new(params[:pcs])
      rhythm, octave = params[:rhythm], params[:octave]
      @results[params] = {
        :forward => arpeggiator.arpeggiate_forward(rhythm, octave),
        :backward => arpeggiator.arpeggiate_backward(rhythm, octave)
      }
    end
  end
    
  describe '#arpeggiate_forward' do
    it 'should produce notes whose pitch classes match the arpeggiator pitch classes' do
      @results.each do |params, results|
        notes = results[:forward]
        notes.map {|note| note.intervals.first.pitch.to_pc }.should eq(params[:pcs])
      end
    end
    
    it 'should produce notes that follow the given rhythm' do
      @results.each do |params, results|
        notes = results[:forward]
        rhythm = params[:rhythm]
        notes.each_index do |i|
          notes[i].duration.should eq(rhythm[i % rhythm.count])
        end
      end
    end
  end

  describe '#arpeggiate_backward' do
    it 'should produce notes whose pitch classes match the arpeggiator pitch classes' do
      @results.each do |params, results|
        notes = results[:backward]
        notes.map {|note| note.intervals.first.pitch.to_pc }.should eq(params[:pcs].reverse)
      end
    end
    
    it 'should produce notes that follow the given rhythm' do
      @results.each do |params, results|
        notes = results[:backward]
        rhythm = params[:rhythm]
        notes.each_index do |i|
          notes[i].duration.should eq(rhythm[i % rhythm.count])
        end
      end
    end
  end
  
end
