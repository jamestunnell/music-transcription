require 'pry'
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
    
    new_parts = {}
    
    # figure parts (note sequences & dynamics)
    score.parts.each do |id, part|
      
      new_part = Musicality::Part.new(
	:loudness_profile => clone_and_collate_profile(part.loudness_profile, score.program.segments),
      )
      
      score.program.segments.each do |seg|
	cur_offset = part.start_offset	
	cur_groups = []
	
	part.note_groups.each do |group|
	  if cur_offset >= seg.first
	    if cur_offset < seg.last
	      cur_groups.push group.clone
	    else
	      if cur_groups.any?
		cur_group_duration = cur_groups.inject(0){|sum,cur_group| cur_group.duration + sum }
		overshoot = cur_group_duration - (seg.last - seg.first)
		cur_groups.last.duration -= overshoot
	      end
	    end
	  end
	  
	  #binding.pry
	  cur_offset += group.duration
	end
	
	#binding.pry
	
	if cur_groups.empty?
	  cur_groups.push NoteGroup.new(:duration => (seg.last - seg.first))
	else
	  # make sure the notes don't have any links past this point
	  cur_groups.last.notes.each do |note|
	    note.link = NoteLink.new
	  end
	end
	
	new_part.note_groups.concat cur_groups
      end
      
      new_parts[id] = new_part
    end    
    
    score.parts = new_parts
    score.beat_duration_profile = clone_and_collate_profile(score.beat_duration_profile, score.program.segments)
    score.beats_per_minute_profile = clone_and_collate_profile(score.beats_per_minute_profile, score.program.segments)
    
    ## find new start/end based on collated parts, and replace
    ## current program segments with a single segment.
    #seg_start = score.parts.values.inject(score.parts.values.first.find_start) {|so_far, part| now = part.find_start; (now < so_far) ? now : so_far }
    #seg_end = score.parts.values.inject(score.parts.values.first.find_end) {|so_far, part| now = part.find_end; (now > so_far) ? now : so_far }
    score.program.segments = [score.find_start...score.find_end]
  end

  private
  
#  def self.modify_group_for_segment seq, seg
#    start_offset = seq.offset
#    notes = []
#    
#    seq.notes.each do |note|
#      if start_offset < seg.first
#	seq.offset += note.duration
#      elsif start_offset < seg.last
#	if (start_offset + note.duration) > seg.last
#	  #reach last sequence note in segment
#	  note.duration = seg.last - start_offset
#	  notes << note
#	  break
#	end
#	
#	notes << note
#      else
#	break
#      end
#      
#      start_offset += note.duration
#    end
#    
#    seq.notes = notes
#  end
  
  def self.modify_event_for_segment event, seg, computer
    if(event.offset + event.duration) > seg.last
      event.duration = seg.last - event.offset
      event.value = computer.value_at seg.last
    end
  end

  def self.clone_and_collate_profile profile, program_segments
    new_profile = SettingProfile.new :start_value => profile.start_value
    
    segment_start_offset = 0.0
    comp = ValueComputer.new profile
  
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