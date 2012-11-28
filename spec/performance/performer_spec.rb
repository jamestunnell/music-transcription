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

    @sequence = Sequence.new :notes => @notes, :offset => 0.0
    @loudness_profile = Musicality::SettingProfile.new :start_value => 0.5
    @part = Musicality::Part.new(
      :offset => 0.0,
      :sequences => [@sequence],
      :instrument_plugins => [ PluginConfig.new(:plugin_name => "oscillator_instrument") ],
      :loudness_profile => @loudness_profile
    )

    sample_rate = 48.0
    @performer = Musicality::Performer.new @part, @sample_rate
  end

  context "Musicality::Performer#prepare_performance_at" do
    it "should deem those notes which come on or after the given note offset as 'to be played' " do
      cases = { 
        0.0 => @sequence.notes,
        0.51 => @sequence.notes[3..5],
        2.01 => []
      }
      
      @performer.sequencers.count.should be 1
      
      cases.each do |offset, notes|
        @performer.prepare_performance_at offset
        
        @performer.sequencers.first.note_events_future.count.should be notes.count
#        @performer.perform_sample offset, @note_time_converter.time_elapsed(0.0, offset)
#        @performer.sequencers.first.note_events_future.count.should be notes.count
#        
#        if notes.empty?
#          @performer.sequencers.first.active?().should be_false
#        else
#          @performer.sequencers.first.active?().should be_true
#          @performer.sequencers.first.note_events_future.count.should be notes.count
#        end
      end
    end
  end
end
