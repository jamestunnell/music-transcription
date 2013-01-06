require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Performer do

  before :each do
    @notes = [ 
      Note.new(:pitch => PitchConstants::C7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::D7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::E7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::C7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::D7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::C7, :duration => 0.75)
    ]
    @sequence = NoteSequence.new :notes => @notes, :offset => 0.0
    @loudness_profile = SettingProfile.new :start_value => 0.5

    part = Part.new(
      :offset => 0.0,
      :note_sequences => [@sequence],
      :loudness_profile => @loudness_profile
    )
    instrument_config = PluginConfig.new(:plugin_name => "oscillator_instrument")
    sample_rate = 48.0
    max_attack_time = 0.15

    @performer = Performer.new part, instrument_config, sample_rate, max_attack_time
  end

  context "Performer#prepare_performance_at" do
    it "should deem those notes which come on or after the given note offset as 'to be played' " do
      cases = { 
        0.0 => @sequence.notes,
        0.5 => @sequence.notes[2..5],
        2.0 => []
      }
      
      @performer.instruction_sequences.count.should eq(@sequence.notes.count)
      
      cases.each do |offset, notes|
        @performer.prepare_performance_at offset

        notes_to_be_started = 0
        @performer.instructions_future.each do |seq_id,instructions|
          if instructions.any? && instructions.first.is_a?(Instructions::On)
            notes_to_be_started += 1
          end
        end
        
        notes_to_be_started.should eq(notes.count)
      end
    end
  end
end
