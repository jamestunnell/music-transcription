require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Performer do

  before :all do
    @note_groups = [
      { :duration => 0.25, :notes => [ { :pitch => PitchConstants::C7 } ]},
      { :duration => 0.25, :notes => [ { :pitch => PitchConstants::D7 } ]},
      { :duration => 0.25, :notes => [ { :pitch => PitchConstants::E7 } ]},
      { :duration => 0.25, :notes => [ { :pitch => PitchConstants::C7 } ]},
      { :duration => 0.25, :notes => [ { :pitch => PitchConstants::D7 } ]},
      { :duration => 0.75, :notes => [ { :pitch => PitchConstants::E7 } ]},
    ]
    loudness_profile = SettingProfile.new :start_value => 0.5
    part = Part.new(:start_offset => 0.0, :note_groups => @note_groups, :loudness_profile => loudness_profile)
    
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
        0.0 => @note_groups,
        0.5 => @note_groups[2..5],
        2.0 => []
      }
      
      @performer.instruction_sequences.count.should eq(@note_groups.count)
      
      cases.each do |offset, note_groups|
        @performer.prepare_performance_at offset

        notes_to_be_started = 0
        @performer.instructions_future.each do |seq_id,instructions|
          if instructions.any? && instructions.first.is_a?(Instructions::On)
            notes_to_be_started += 1
          end
        end
        
        notes_to_be_started.should eq(note_groups.count)
      end
    end
  end
  
  #context "Performer#find_note_attack_time " do
  #  it 'should....' do
  #    attack_time = @performer.find_note_attack_time @sequence.notes.first
  #    puts
  #    puts "attack_time is #{attack_time}"
  #  end
  #end
end
