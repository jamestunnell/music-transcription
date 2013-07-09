require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::PitchClassArpeggiator do
  describe '.new' do
    before :all do
      @good_pcs = PitchClassSet.new([0,1,2])
      @bad_pcs = PitchClassSet.new()
    end
    
    it 'should raise an ArgumentError if empty pitch class set is given' do
      ->(){ PitchClassArpeggiator.new(@bad_pcs) }.should raise_error(ArgumentError)
    end

    it 'should not raise an ArgumentError otherwise' do
      ->(){ PitchClassArpeggiator.new(@good_pcs) }.should_not raise_error
    end
  end

  before :all do
    @rhythms = [
      [0.25, 0.125, 0.5, 0.125],
      [Rational(1,6), Rational(1,6), Rational(1,6)],
      [Rational(1,4)],
      [Rational(1,4), Rational(1,2)],
    ]
      
    @rising_pitch_ranges = [
      PitchRange::Closed.new(F4,F5),
      PitchRange::OpenRight.new(C2,C4),
      PitchRange::OpenLeft.new(C2,C4),
      PitchRange::Closed.new(E3,G7),
      PitchRange::Open.new(E3,G7),
    ]
    
    @falling_pitch_ranges = [
      PitchRange::Closed.new(F5,F4),
      PitchRange::OpenRight.new(C4,C2),
      PitchRange::OpenLeft.new(C4,C2),
      PitchRange::Closed.new(G7,E3),
      PitchRange::Open.new(G7,E3),
    ]
    
    @arpeggiators = [
      PitchClassArpeggiator.new(pcs([0,4,7])),
      PitchClassArpeggiator.new(pcs([1,3,11])),
      PitchClassArpeggiator.new(pcs([4,5,12])),
    ]
  end
    
  describe '#rising_arpeggio_over_range' do
    it 'should produce notes whose pitches are part of the given pitch class set (except first & last note)' do
      @arpeggiators.each do |arpeggiator|
        @rising_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.rising_arpeggio_over_range pitch_range, rhythm
            arpeggio[1..-2].each do |note|
              arpeggiator.pitch_class_set.should include note.intervals.first.pitch.semitone
            end
          end
        end
      end
    end
    
    it 'should produce notes that follow the given rhythm' do
      @arpeggiators.each do |arpeggiator|
        @rising_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.rising_arpeggio_over_range pitch_range, rhythm

            arpeggio.each_index do |i|
              note = arpeggio[i]
              note.duration.should eq(rhythm[i % rhythm.count])
            end
          end
        end
      end
    end

    it 'should end with range.left, unless range excludes left' do
      @arpeggiators.each do |arpeggiator|
        @rising_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.rising_arpeggio_over_range pitch_range, rhythm
            if pitch_range.include_left?
              arpeggio.first.intervals.first.pitch.should eq pitch_range.left
            else
              arpeggio.first.intervals.first.pitch.should_not eq pitch_range.left
            end
          end
        end
      end
    end
    
    it 'should end with range.right, unless range excludes right' do
      @arpeggiators.each do |arpeggiator|
        @rising_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.rising_arpeggio_over_range pitch_range, rhythm
            if pitch_range.include_right?
              arpeggio.last.intervals.first.pitch.should eq pitch_range.right
            else
              arpeggio.last.intervals.first.pitch.should_not eq pitch_range.right
            end
          end
        end
      end
    end
  end

  describe '#falling_arpeggio_over_range' do
    it 'should produce notes whose pitches are part of the given pitch class set (except first & last note)' do
      @arpeggiators.each do |arpeggiator|
        @falling_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.falling_arpeggio_over_range pitch_range, rhythm
            arpeggio[1..-2].each do |note|
              arpeggiator.pitch_class_set.should include note.intervals.first.pitch.semitone
            end
          end
        end
      end
    end
    
    it 'should produce notes that follow the given rhythm' do
      @arpeggiators.each do |arpeggiator|
        @falling_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.falling_arpeggio_over_range pitch_range, rhythm

            arpeggio.each_index do |i|
              note = arpeggio[i]
              note.duration.should eq(rhythm[i % rhythm.count])
            end
          end
        end
      end
    end

    it 'should end with range.left, unless range excludes left' do
      @arpeggiators.each do |arpeggiator|
        @falling_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.falling_arpeggio_over_range pitch_range, rhythm
            if pitch_range.include_left?
              arpeggio.first.intervals.first.pitch.should eq pitch_range.left
            else
              arpeggio.first.intervals.first.pitch.should_not eq pitch_range.left
            end
          end
        end
      end
    end
    
    it 'should end with range.right, unless range excludes right' do
      @arpeggiators.each do |arpeggiator|
        @falling_pitch_ranges.each do |pitch_range|
          @rhythms.each do |rhythm|
            arpeggio = arpeggiator.falling_arpeggio_over_range pitch_range, rhythm
            if pitch_range.include_right?
              arpeggio.last.intervals.first.pitch.should eq pitch_range.right
            else
              arpeggio.last.intervals.first.pitch.should_not eq pitch_range.right
            end
          end
        end
      end
    end
  end
  
end
