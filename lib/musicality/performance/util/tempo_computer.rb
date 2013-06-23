module Musicality

# Computer tempo at any offset. Uses a ValueComputer for beat duration and beats per minute to compute tempo.
#
# @author James Tunnell
#
class TempoComputer < ValueComputer
  
  # A new instance of TempoComputer.
  # @param [Profile] tempo_profile A Profile for beats per minute and beat duration.
  def initialize tempo_profile
    @tempo_profile = tempo_profile
    
    bpm_start = tempo_profile.start_value.beats_per_minute
    bd_start = tempo_profile.start_value.beat_duration
    
    bpm_changes = {}
    bd_changes = {}
    
    tempo_profile.value_changes.each do |offset,value_change|
      bpm = value_change.value.beats_per_minute
      bd = value_change.value.beat_duration
      
      bpm_change = ValueChange.new(:value => bpm, :transition => value_change.transition)
      bd_change = ValueChange.new(:value => bd, :transition => value_change.transition)
      
      bpm_changes[offset] = bpm_change
      bd_changes[offset] = bd_change
    end
    
    bpm_profile = Profile.new(:start_value => bpm_start, :value_changes => bpm_changes)
    bd_profile = Profile.new(:start_value => bd_start, :value_changes => bd_changes)
    
    @bpm_comp = ValueComputer.new bpm_profile
    @bd_comp = ValueComputer.new bd_profile
  end

  # Compute the tempo at the given offset.
  # @param [Numeric] offset The given offset to compute tempo at.  
  def value_at offset
    bpm = @bpm_comp.value_at(offset)
    bd = @bd_comp.value_at(offset)
    return Tempo.new(:beats_per_minute => bpm, :beat_duration => bd)
  end
  
  # Compute the notes per second at the given offset.
  # @param [Numeric] offset The given offset to compute tempo at.
  def notes_per_second_at offset
    value_at(offset).notes_per_second
  end
end

end
