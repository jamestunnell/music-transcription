require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Performer do

  before :all do
    notes = [ 
      Note.new(:pitch => PitchConstants::C7, :duration => 0.25, :attack => 0.5),
      Note.new(:pitch => PitchConstants::D7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::E7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::C7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::D7, :duration => 0.25),
      Note.new(:pitch => PitchConstants::C7, :duration => 0.75)
    ]
    @sequence = NoteSequence.new :notes => notes, :offset => 0.0
    loudness_profile = SettingProfile.new :start_value => 0.5

    part = Part.new(
      :offset => 0.0,
      :note_sequences => [@sequence],
      :loudness_profile => loudness_profile
    )
    
    sample_rate = 5000.0
    max_attack_time = 0.15
    
    instrument_config = InstrumentFinder::DEFAULT_INSTRUMENT_PLUGIN
    settings = { :sample_rate => sample_rate }.merge(instrument_config.settings)
    plugin = PLUGINS.plugins[instrument_config.plugin_name.to_sym]
    instrument = plugin.make_instrument(settings)

    @performer = Performer.new part, instrument, max_attack_time
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
  
  context "Performer#find_note_attack_time " do
    it 'should....' do
      attack_time = @performer.find_note_attack_time @sequence.notes.first
      puts
      puts "attack_time is #{attack_time}"
    end
  end
end
