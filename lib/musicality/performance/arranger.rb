module Musicality

# Finds an instrument for each part in a score.
#
# @author James Tunnell
#
# @!attribute [r] default_instrument_config
#   @return [InstrumentConfig] If no config is specific for a part, or if the
#                              config cannot be used, the default config will
#                              be used.
#
class Arranger

  attr_reader :default_instrument_config, :plugin_dirs

  # A new instance of Arranger.
  #
  # @param [Hash] args Hashed arguments. Optional keys are
  #                    :default_instrument_plugin and :plugin_dirs.
  def initialize args = {}
    default_instrument_plugin = PluginConfig.new(
      :plugin_name => 'oscillator_instrument',
      :settings => {
        :wave_type => SettingProfile.new( :start_value => 'square' )
      }
    )

    args = {
      :default_instrument_plugin => default_instrument_plugin,
      :plugin_dirs => [] # File.expand_path(File.dirname(__FILE__))
    }.merge args
    
    @default_instrument_plugin = args[:default_instrument_plugin]
    @plugin_dirs = args[:plugin_dirs]
    
    @plugin_dirs.each do |dir|
      puts "loading plugins from #{dir}"
      PLUGINS.load_plugins dir
    end
    
    unless PLUGINS.plugins.has_key?(@default_instrument_plugin.plugin_name.to_sym)
      raise ArgumentError, "default instrument plugin #{@default_instrument_plugin.plugin_name} is not registered"
    end
  end
  
  # Make an Arrangment from a Score, which includes converting note-based
  # offsets & durations to time-based.
  # @param [Score] score The score to be used to make an Arrangement.
  # @param [Numeric] conversion_sample_rate The sample rate used in converting
  #                                         from note-base to time-base
  def make_arrangement score, conversion_sample_rate = 1000.0
    raise ArgumentError, "score has no parts" unless score.parts.any?
    raise ArgumentError, "conversion_sample_rate is not a Numeric" unless conversion_sample_rate.is_a?(Numeric)
    raise ArgumentError, "conversion_sample_rate is less than 100.0" if conversion_sample_rate < 100.0
    
    parts = make_time_based_parts_from_score score, conversion_sample_rate
        
    parts.each do |part|
      part.instrument_plugins.keep_if { |plugin| PLUGINS.plugins.has_key? plugin.plugin_name.to_sym }
      
      if part.instrument_plugins.empty?
        part.instrument_plugins << @default_instrument_plugin
      end
      
      part.effect_plugins.keep_if { |plugin| PLUGINS.plugins.has_key? plugin.plugin_name.to_sym }

    end
    
    return Arrangement.new(parts)
  end
  
  private

  # Convert note-based offsets & durations to time-based. This eliminates
  # the use of tempo during performance.
  # @param [Score] score The score to process. It will be collated if
  #                      it is not already.
  # @param [Numeric] conversion_sample_rate The sample rate to use in
  #                                         converting from note-base to
  #                                         time-base.
  def make_time_based_parts_from_score score, conversion_sample_rate
    
    ScoreCollator.collate_score! score
    
    #gather all the note offets to be converted to time offsets
    
    note_offsets = Set.new [0.0]
    
    score.parts.each do |part|
      part.sequences.each do |sequence|
        offset = sequence.offset
        note_offsets << offset
        
        sequence.notes.each do |note|
          offset += note.duration
          note_offsets << offset
        end
      end
      
      part.loudness_profile.value_change_events.each do |a|
        note_offsets << a.offset
      end
    end
    
    # convert note offsets to time offsets
    
    tempo_computer = TempoComputer.new( score.beat_duration_profile, score.beats_per_minute_profile )
    note_time_converter = NoteTimeConverter.new tempo_computer, conversion_sample_rate
    note_time_map = note_time_converter.map_note_offsets_to_time_offsets note_offsets
    
    new_parts = []
    score.parts.each do |part|
      new_part = Musicality::Part.new(
        :loudness_profile => SettingProfile.new(:start_value => part.loudness_profile.start_value),
	:instrument_plugins => part.instrument_plugins,
	:effect_plugins => part.effect_plugins,
        :id => part.id
      )
      
      part.sequences.each do |sequence|
        
        note_start_offset = sequence.offset
        raise "Note-time map does not have sequence start note offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
        new_sequence = Musicality::Sequence.new :offset => note_time_map[note_start_offset]
        
        sequence.notes.each do |note|
          note_end_offset = note_start_offset + note.duration
          
          raise "Note-time map does not have note start offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
          raise "Note-time map does not have note end offset key #{note_end_offset}" unless note_time_map.has_key?(note_end_offset)
          
          time_duration = note_time_map[note_end_offset] - note_time_map[note_start_offset]
          new_note = Musicality::Note.new(
            :duration => time_duration, :pitches => note.pitches, :sustain => note.sustain,
            :attack => note.attack, :seperation => note.seperation, :relationship => note.relationship
          )
          
          new_sequence.notes << new_note
          note_start_offset += note.duration
        end
        
        new_part.sequences << new_sequence
      end
      
      part.loudness_profile.value_change_events.each do |event|
        note_start_offset = event.offset
        note_end_offset = note_start_offset + event.duration
        raise "Note-time map does not have note start offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
        raise "Note-time map does not have note end offset key #{note_end_offset}" unless note_time_map.has_key?(note_end_offset)
        
        start_time = note_time_map[note_start_offset]
        duration = note_time_map[note_end_offset] - start_time
        
        new_event = Musicality::Event.new start_time, event.value, duration
        new_part.loudness_profile.value_change_events << new_event
      end
      
      new_parts << new_part
    end
    
    return new_parts
  end

end
end
