require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::IntervalVectorArpeggiator do
  before :all do
    @cases = [
      {
        :interval_vector => IntervalVector.new([1,2,1]),
        :rising_pitch_range => PitchRange::Closed.new(C3,F3),
        :falling_pitch_range => PitchRange::Closed.new(F3,C3),
        :rhythm => [0.25],
        :expected_rising_arpeggio_over_range => [
          note(0.25, [interval(C3)]),
          note(0.25, [interval(Db3)]),
          note(0.25, [interval(Eb3)]),
          note(0.25, [interval(E3)]),
          note(0.25, [interval(F3)])
        ],
        :expected_falling_arpeggio_over_range => [
          note(0.25, [interval(F3)]),
          note(0.25, [interval(E3)]),
          note(0.25, [interval(D3)]),
          note(0.25, [interval(Db3)]),
          note(0.25, [interval(C3)])
        ]
      },
      {
        :interval_vector => IntervalVector.new([4,3,5]),
        :rising_pitch_range => PitchRange::OpenRight.new(C3,C5),
        :falling_pitch_range => PitchRange::OpenRight.new(C5,C3),
        :rhythm => [0.25],
        :expected_rising_arpeggio_over_range => [
          note(0.25, [interval(C3)]),
          note(0.25, [interval(E3)]),
          note(0.25, [interval(G3)]),
          note(0.25, [interval(C4)]),
          note(0.25, [interval(E4)]),
          note(0.25, [interval(G4)]),
        ],
        :expected_falling_arpeggio_over_range => [
          note(0.25, [interval(C5)]),
          note(0.25, [interval(Ab4)]),
          note(0.25, [interval(F4)]),
          note(0.25, [interval(C4)]),
          note(0.25, [interval(Ab3)]),
          note(0.25, [interval(F3)]),
        ]
      },
      {
        :interval_vector => IntervalVector.new([-1,2]),
        :rising_pitch_range => PitchRange::OpenLeft.new(Db5,F5),
        :falling_pitch_range => PitchRange::OpenLeft.new(F5,Db5),
        :rhythm => [0.25,0.125],
        :expected_rising_arpeggio_over_range => [
          #note(0.25, [interval(Db5)]),
          note(0.25, [interval(C5)]),
          note(0.125, [interval(D5)]),
          note(0.25, [interval(Db5)]),
          note(0.125, [interval(Eb5)]),
          note(0.25, [interval(D5)]),
          note(0.125, [interval(E5)]),
          note(0.25, [interval(Eb5)]),
          note(0.125, [interval(F5)]),
        ],
        :expected_falling_arpeggio_over_range => [
          #note(0.25, [interval(F5)]),
          note(0.25, [interval(Gb5)]),
          note(0.125, [interval(E5)]),
          note(0.25, [interval(F5)]),
          note(0.125, [interval(Eb5)]),
          note(0.25, [interval(E5)]),
          note(0.125, [interval(D5)]),
          note(0.25, [interval(Eb5)]),
          note(0.125, [interval(Db5)]),
        ]
      },
      {
        :interval_vector => IntervalVector.new([2,3]),
        :rising_pitch_range => PitchRange::Open.new(G4,C6),
        :falling_pitch_range => PitchRange::Open.new(C6,G4),
        :rhythm => [0.25,0.25,-0.25],
        :expected_rising_arpeggio_over_range => [
          #note(0.25, [interval(G4)]),
          note(0.25, [interval(A4)]),
          note(0.25, [interval(C5)]),
          note(0.25),
          note(0.25, [interval(F5)]),
          note(0.25, [interval(G5)]),
          note(0.25),
          #note(0.25, [interval(C6)]),
        ],
        :expected_falling_arpeggio_over_range => [
          #note(0.25, [interval(C6)]),
          note(0.25, [interval(Bb5)]),
          note(0.25, [interval(G5)]),
          note(0.25),
          note(0.25, [interval(D5)]),
          note(0.25, [interval(C5)]),
          note(0.25),
        ]
      },
    ]
  end

  describe '#rising_arpeggio_over_range' do    
    it 'should produce notes with the expected pitches for the given interval vector and pitch range' do
      @cases.each do |case_hash|
        arpeggiator = IntervalVectorArpeggiator.new case_hash[:interval_vector]
        expected_arpeggio = case_hash[:expected_rising_arpeggio_over_range]
        actual_arpeggio = arpeggiator.rising_arpeggio_over_range case_hash[:rising_pitch_range], case_hash[:rhythm]
        actual_arpeggio.should eq(expected_arpeggio)
      end
    end
  end

  describe '#falling_arpeggio_over_range' do
    it 'should produce notes with the expected pitches for the given interval vector and pitch range' do
      @cases.each do |case_hash|
        arpeggiator = IntervalVectorArpeggiator.new case_hash[:interval_vector]
        expected_arpeggio = case_hash[:expected_falling_arpeggio_over_range]
        actual_arpeggio = arpeggiator.falling_arpeggio_over_range case_hash[:falling_pitch_range], case_hash[:rhythm]
        actual_arpeggio.should eq(expected_arpeggio)
      end
    end
  end
  
end
