require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Performer do

  C9 = Musicality::Pitch.new :octave => 9, :semitone => 0
  D9 = Musicality::Pitch.new :octave => 9, :semitone => 2
  E9 = Musicality::Pitch.new :octave => 9, :semitone => 4

  before :each do
    @notes = [ 
      Musicality::Note.new(:pitch => C9, :duration => 0.25, :offset => 0.00 ),
      Musicality::Note.new(:pitch => D9, :duration => 0.25, :offset => 0.25 ),
      Musicality::Note.new(:pitch => E9, :duration => 0.25, :offset => 0.50 ),
      Musicality::Note.new(:pitch => C9, :duration => 0.25, :offset => 0.75 ),
      Musicality::Note.new(:pitch => D9, :duration => 0.25, :offset => 1.00 ),
      Musicality::Note.new(:pitch => C9, :duration => 0.75, :offset => 1.25 )
    ]

    @instrument = Musicality::Instrument.new :class_name => Musicality::SineWave.name
    @part = Musicality::Part.new :notes => @notes, :instrument => @instrument

    tempos = [
      Musicality::Tempo.new( { :beat_duration => 0.25, :beats_per_minute => 300, :offset => 0.0 } ),
      Musicality::Tempo.new( { :beat_duration => 0.25, :beats_per_minute => 100, :offset => 1.0, :duration => 1.25 } )
    ]
    
    sample_rate = 48.0
    @tempo_computer = TempoComputer.new( Event.hash_events_by_offset tempos )
    @note_time_converter = NoteTimeConverter.new @tempo_computer, sample_rate
    @performer = Musicality::Performer.new @part, @tempo_computer, @note_time_converter
  end

  it "should find and instantiate the part's instrument class" do
    @performer.instrument.class.name.should eq(@instrument.class_name)
  end

  context "Musicality::Performer#prepare_to_perform" do
    it "should deem those notes which come on or after the given note offset as 'to be played' " do
      cases = { 
        0.0 => @notes,
        0.51 => @notes[3..5],
        1.26 => [] 
      }
      
      cases.each do |offset, notes|
        @performer.prepare_to_perform offset
        @performer.notes_to_be_played.should eq(notes)
      end
    end
  end
end
