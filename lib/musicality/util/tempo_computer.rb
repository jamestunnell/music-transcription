module Musicality

# Computer tempo at any offset. Uses a ValueComputer for beat duration and beats per minute to compute tempo.
#
# @author James Tunnell
#
class TempoComputer
  
  # A new instance of TempoComputer.
  # @param [SettingProfile] beat_duration_profile A SettingProfile for beat duration.
  # @param [SettingProfile] beats_per_minute_profile A SettingProfile for beats per minute.
  def initialize beat_duration_profile, beats_per_minute_profile
    @beat_duration_computer = ValueComputer.new(beat_duration_profile.start_value, beat_duration_profile.value_change_events)
    @beats_per_minute_computer = ValueComputer.new(beats_per_minute_profile.start_value, beats_per_minute_profile.value_change_events)
  end
  
  # Compute the beats per minute at the given offset.
  # @param [Numeric] offset The given offset to compute beats per minute at.
  def beats_per_minute_at offset
    @beats_per_minute_computer.value_at(offset)
  end
  
  # Compute the beat duration at the given offset.
  # @param [Numeric] offset The given offset to compute tempo at.
  def beat_duration_at_at offset
    @beat_duration_computer.value_at(offset)
  end
  
  # Compute the notes per second at the given offset.
  # @param [Numeric] offset The given offset to compute tempo at.
  def notes_per_second_at offset
    bpm = @beats_per_minute_computer.value_at(offset)
    nps = (bpm / 60.0) * @beat_duration_computer.value_at(offset)
  end
end

end
