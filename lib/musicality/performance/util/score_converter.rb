module Musicality

# Utility class to perform conversions on a score. 
class ScoreConverter

  # Convert note-based offsets & durations to time-based. This eliminates
  # the use of tempo during performance.
  # @param [Score] score The score to process. It will be collated if
  #                      it is not already.
  # @param [Numeric] conversion_sample_rate The sample rate to use in
  #                                         converting from note-base to
  #                                         time-base.
  def self.make_time_based_parts_from_score score, conversion_sample_rate
    if score.program.segments.count > 1
      self.collate_score!(score)
    end
    
    #gather all the note offets to be converted to time offsets
    
    note_offsets = Set.new [0.0]
    
    score.parts.each do |id, part|
      part.note_sequences.each do |sequence|
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
    
    new_parts = {}
    score.parts.each do |id, part|
      new_part = Musicality::Part.new(
        :loudness_profile => SettingProfile.new(:start_value => part.loudness_profile.start_value),
      )
      
      part.note_sequences.each do |sequence|
        
        note_start_offset = sequence.offset
        raise "Note-time map does not have sequence start note offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
        new_sequence = Musicality::NoteSequence.new :offset => note_time_map[note_start_offset]
        
        sequence.notes.each do |note|
          note_end_offset = note_start_offset + note.duration
          
          raise "Note-time map does not have note start offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
          raise "Note-time map does not have note end offset key #{note_end_offset}" unless note_time_map.has_key?(note_end_offset)
          
          time_duration = note_time_map[note_end_offset] - note_time_map[note_start_offset]
          new_note = Musicality::Note.new(
            :duration => time_duration, :pitch => note.pitch, :sustain => note.sustain,
            :attack => note.attack, :seperation => note.seperation, :relationship => note.relationship
          )
          
          new_sequence.notes << new_note
          note_start_offset += note.duration
        end
        
        new_part.note_sequences << new_sequence
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
      
      new_parts[id] = new_part
    end
    
    return new_parts
  end

end

end
