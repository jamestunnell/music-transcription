require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Performer do

  before :each do
    @notes = [ 
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::C7], :duration => 0.25),
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::D7], :duration => 0.25),
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::E7], :duration => 0.25),
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::C7], :duration => 0.25),
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::D7], :duration => 0.25),
      Musicality::Note.new(:pitches => [Musicality::PitchConstants::C7], :duration => 0.75)
    ]

    @sequence = NoteSequence.new :notes => @notes, :offset => 0.0
    @loudness_profile = Musicality::SettingProfile.new :start_value => 0.5
    part = Musicality::Part.new(
      :offset => 0.0,
      :note_sequences => [@sequence],
      :instrument_plugins => [ PluginConfig.new(:plugin_name => "oscillator_instrument") ],
      :loudness_profile => @loudness_profile
    )
    @arranged_part = ArrangedPart.new part

    sample_rate = 48.0
    @performer = Musicality::Performer.new @arranged_part, @sample_rate
  end

  context "Musicality::Performer#prepare_performance_at" do
    it "should deem those notes which come on or after the given note offset as 'to be played' " do
      cases = { 
        0.0 => @sequence.notes,
        0.5 => @sequence.notes[2..5],
        2.0 => []
      }
      
      @performer.arranged_part.instruction_sequences.count.should eq(@notes.count)
      
      cases.each do |offset, notes|
        @performer.prepare_performance_at offset

        notes_to_be_started = 0
        @performer.instructions_future.each do |seq_id,instructions|
          if instructions.any? && instructions.first.type == Instruction::ON
            notes_to_be_started += 1
          end
        end
        
        notes_to_be_started.should eq(notes.count)
      end
    end
  end
end
