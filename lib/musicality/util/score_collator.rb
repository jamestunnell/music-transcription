module Musicality

# Combine multiple program segments to one, using
# tempo/note/dynamic replication and truncation where necessary.
#
# @author James Tunnell
class ScoreCollator
  
  # Combine multiple program segments to one, using
  # tempo/note/dynamic replication and truncation where necessary.
  #
  # @param [Score] score The score to be collated.
  #
  def self.collate_score! score
    return if score.program.segments.count <= 1
    
    new_parts = []
    
    # figure parts (note sequences & dynamics)
    score.parts.each do |part|
      
      new_part = Musicality::Part.new(
	:loudness_profile => clone_and_collate_profile(part.loudness_profile, score.program.segments),
	:instrument_plugins => part.instrument_plugins,
	:effect_plugins => part.effect_plugins,
	:id => part.id
      )
      segment_start_offset = 0.0
      
      score.program.segments.each do |seg|
	# figure which sequences to keep/modify
	sequences = Marshal.load(Marshal.dump(part.sequences))
	sequences.each do |seq|
	  modify_seq_for_segment seq, seg
	end
	sequences.keep_if {|seq| seq.notes.any? }

	# add sequences to part, adjusting for segment start offset
	sequences.each do |sequence|
	  sequence.offset = (sequence.offset - seg.first) + segment_start_offset
	  new_part.sequences << sequence
	end	

	segment_start_offset += (seg.last - seg.first)
      end
      
      new_parts << new_part
    end    
    
    score.parts = new_parts
    score.beat_duration_profile = clone_and_collate_profile(score.beat_duration_profile, score.program.segments)
    score.beats_per_minute_profile = clone_and_collate_profile(score.beats_per_minute_profile, score.program.segments)
  end

  private
  
  def self.modify_seq_for_segment seq, seg
    start_offset = seq.offset
    notes = []
    
    seq.notes.each do |note|
      if start_offset < seg.first
	seq.offset += note.duration
      elsif start_offset < seg.last
	if (start_offset + note.duration) > seg.last
	  #reach last sequence note in segment
	  note.duration = seg.last - start_offset
	  notes << note
	  break
	end
	
	notes << note
      else
	break
      end
      
      start_offset += note.duration
    end
    
    seq.notes = notes
  end
  
  def self.modify_event_for_segment event, seg, computer
    if(event.offset + event.duration) > seg.last
      event.duration = seg.last - event.offset
      event.value = computer.value_at seg.last
    end
  end

  def self.clone_and_collate_profile profile, program_segments
    new_profile = SettingProfile.new :start_value => profile.start_value
    
    segment_start_offset = 0.0
    comp = ValueComputer.new profile.start_value, profile.value_change_events
  
    program_segments.each do |seg|
      # figure which dynamics to keep/modify
      changes = Marshal.load(Marshal.dump(profile.value_change_events))
      changes.keep_if {|change| change.offset >= seg.first && change.offset < seg.last}
      changes.each do |change|
	modify_event_for_segment change, seg, comp
      end
      
      # find & add segment start dynamic first
      value = comp.value_at seg.first
      offset = segment_start_offset
      new_profile.value_change_events << Event.new(offset, value)
      
      # add dynamics to part, adjusting for segment start offset
      changes.each do |change|
	change.offset = (change.offset - seg.first) + segment_start_offset
	new_profile.value_change_events << change
      end	
      
      segment_start_offset += (seg.last - seg.first)
    end
    
    return new_profile
  end

end
end