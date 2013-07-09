require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::IntervalVectorArpeggiator do    
  describe '#rising_arpeggio_over_range' do
    before :all do
      @cases = [
        {
          :interval_vector => RelativeIntervalVector.new([1,2,1]),
          :pitch_range => (C3..F3),
          :rhythm => [0.25],
          :expected_arpeggio => [
            note(0.25, [interval(C3)]),
            note(0.25, [interval(Db3)]),
            note(0.25, [interval(Eb3)]),
            note(0.25, [interval(E3)]),
            note(0.25, [interval(F3)])
          ]
        },
        {
          :interval_vector => AbsoluteIntervalVector.new([4,7,12]),
          :pitch_range => (C3...C5),
          :rhythm => [0.25],
          :expected_arpeggio => [
            note(0.25, [interval(C3)]),
            note(0.25, [interval(E3)]),
            note(0.25, [interval(G3)]),
            note(0.25, [interval(C4)]),
            note(0.25, [interval(E4)]),
            note(0.25, [interval(G4)]),
          ]
        },
        {
          :interval_vector => RelativeIntervalVector.new([-1,2]),
          :pitch_range => (Db5..F5),
          :rhythm => [0.25],
          :expected_arpeggio => [
            note(0.25, [interval(Db5)]),
            note(0.25, [interval(C5)]),
            note(0.25, [interval(D5)]),
            note(0.25, [interval(Db5)]),
            note(0.25, [interval(Eb5)]),
            note(0.25, [interval(D5)]),
            note(0.25, [interval(E5)]),
            note(0.25, [interval(Eb5)]),
            note(0.25, [interval(F5)]),
          ]
        },
        {
          :interval_vector => AbsoluteIntervalVector.new([2,5]),
          :pitch_range => (G4...A5),
          :rhythm => [0.25,0.25,-0.25],
          :expected_arpeggio => [
            note(0.25, [interval(G4)]),
            note(0.25, [interval(A4)]),
            note(0.25),
            note(0.25, [interval(D5)]),
            note(0.25, [interval(F5)]),
            note(0.25),
          ]
        },
      ]
    end
    
    it 'should produce notes with the expected pitches for the given interval vector and pitch range' do
      @cases.each do |case_hash|
        arpeggiator = IntervalVectorArpeggiator.new case_hash[:interval_vector]
        actual_arpeggio = arpeggiator.rising_arpeggio_over_range case_hash[:pitch_range], case_hash[:rhythm]
        actual_arpeggio.should eq(case_hash[:expected_arpeggio])
      end
    end
  end

  describe '#falling_arpeggio_over_range' do
  end
  
end
