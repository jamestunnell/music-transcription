require 'pry'
module Musicality

# Combine multiple program segments to one, using
# tempo/note/dynamic replication and truncation where necessary.
#
# @author James Tunnell
class ScoreCollator

  # Combine multiple program segments to one, using tempo/note/dynamic replication
  # and truncation where necessary. Returns a modified clone of the given score.
  #
  # @param [Score] score The score to be collated. Not modified by this method.
  # 
  def self.collate_score score
    score = Marshal.load(Marshal.dump(score))
    self.collate_score! score
    return score
  end
  
  # Combine multiple program segments to one, using tempo/note/dynamic replication
  # and truncation where necessary. Modifies given score.
  #
  # @param [Score] score The score to be collated. Modified in place.
  #
  def self.collate_score! score
    return score if score.program.segments.count <= 1
    
    new_parts = {}
    
    # figure parts (note sequences & dynamics)
    score.parts.each do |id, part|
      
      new_part = Musicality::Part.new(
	:loudness_profile => clone_and_collate_profile(part.loudness_profile, score.program.segments),
      )
      
      score.program.segments.each do |seg|
	cur_offset = part.start_offset	
	cur_notes = []
	
	part.notes.each do |note|
	  if cur_offset >= seg.first && cur_offset < seg.last
	    cur_notes.push note.clone
	  end
	  cur_offset += note.duration
	end
	
	cur_note_duration = cur_notes.inject(0){|sum,cur_note| cur_note.duration + sum }
	overshoot = cur_note_duration - (seg.last - seg.first)
	
	if overshoot > 0
	  cur_notes.last.duration -= overshoot
	end
	
	cur_note_duration = cur_notes.inject(0){|sum,cur_note| cur_note.duration + sum }
	undershoot = (seg.last - seg.first) - cur_note_duration
	if undershoot > 0
	  cur_notes.push Note.new(:duration => undershoot)
	end
	      
	if cur_notes.any?
	  # make sure the notes don't have any links past this point
	  cur_notes.last.intervals.each do |interval|
	    interval.link = Link.new
	  end
	end
	
	new_part.notes.concat cur_notes
      end
      
      new_parts[id] = new_part
    end    
    
    score.parts = new_parts
    score.beats_per_minute_profile = clone_and_collate_profile(score.beats_per_minute_profile, score.program.segments)
    score.beat_duration_profile = clone_and_collate_profile(score.beats_per_minute_profile, score.program.segments)
    score.program.segments = [score.find_start...score.find_end]
    
    return score
  end

  private
  
  def self.modify_change_for_segment change, offset, seg, computer
    if(offset + change.transition.duration) > seg.last
      change.transition.duration = seg.last - offset
      change.value = computer.value_at seg.last
    end
  end

  def self.clone_and_collate_profile profile, program_segments
    new_profile = Profile.new :start_value => profile.start_value
    
    segment_start_offset = 0.0
    comp = ValueComputer.new profile
    
    program_segments.each do |seg|
      # figure which dynamics to keep/modify
      changes = Marshal.load(Marshal.dump(profile.value_changes))
      changes.keep_if {|offset,change| seg.include?(offset) }
      changes.each do |offset, change|
	modify_change_for_segment change, offset, seg, comp
      end
      
      # find & add segment start dynamic first
      value = comp.value_at seg.first
      offset = segment_start_offset
      new_profile.value_changes[offset] = Musicality::value_change(value)
      
      # add dynamics to part, adjusting for segment start offset
      changes.each do |offset2, change|
	offset3 = (offset2 - seg.first) + segment_start_offset
	new_profile.value_changes[offset3] = change
      end	
      
      segment_start_offset += (seg.last - seg.first)
    end
    
    return new_profile
  end

end
end