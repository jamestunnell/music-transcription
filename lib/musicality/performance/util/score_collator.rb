require 'pry'
module Musicality

# Combine multiple program segments to one, using
# tempo/note/dynamic replication and truncation where necessary.
#
# @author James Tunnell
class Score

  # Combine multiple program segments to one, using tempo/note/dynamic replication
  # and truncation where necessary. Returns a modified clone of the current score.
  #
  def collate
    return self.clone.collate!
  end
  
  # Combine multiple program segments to one, using note/dynamic replication
  # and truncation where necessary. Modifies current score.
  #
  def collate!
    return self if @program.segments.count <= 1
    
    new_parts = {}
    
    # figure parts (note sequences & dynamics)
    @parts.each do |id, part|
      
      new_part = Musicality::Part.new(
	:loudness_profile => part.loudness_profile.clone_and_collate(ValueComputer, @program.segments)
      )
      
      @program.segments.each do |seg|
	cur_offset = part.offset	
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
    
    @parts = new_parts
    @program.segments = [self.start...self.end]
    
    return self
  end
end

class TempoScore
  
  alias old_collate collate
  alias old_collate! collate!
  
  def collate
    self.clone.collate!
  end
  
  def collate!
    @tempo_profile = @tempo_profile.clone_and_collate(TempoComputer, @program.segments)
    old_collate!
    return self
  end
end

end