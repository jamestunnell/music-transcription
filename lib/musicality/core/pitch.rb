module Musicality

  class Pitch
	include Comparable
  
	attr_reader :octave, :semitone, :cent

	SEMITONES_PER_OCTAVE = 12
	CENTS_PER_SEMITONE = 100

	def initialize args={}
	  if args[:octave]
		raise ArgumentError, "args[:octave] #{args[:octave]} is not a Fixnum" if !args[:octave].is_a?(Fixnum)
	  end
	  @octave = args[:octave] || 0
	  
	  if args[:semitone]
		raise ArgumentError, "args[:semitone] #{args[:semitone]} is not a Fixnum" if !args[:semitone].is_a?(Fixnum)
	  end
	  @semitone = args[:semitone] || 0
	  
	  if args[:cent]
		raise ArgumentError, "args[:cent] #{args[:cent]} is not a Fixnum" if !args[:cent].is_a?(Fixnum)
	  end
	  @cent = args[:cent] || 0
	  
	  @cents_per_octave = CENTS_PER_SEMITONE * SEMITONES_PER_OCTAVE
      normalize
	  
	  #if args[:ratio]
	  #  ratio = args[:ratio]
	  #end
	end
    
	def total_cent
	  return (@octave * @cents_per_octave) +
						(@semitone * CENTS_PER_SEMITONE) + @cent
	end
    
	def total_cent= cent
	  @octave, @semitone, @cent = 0, 0, cent
	  normalize
	end
	
	def ratio
	  2.0**(total_cent.to_f / @cents_per_octave)
	end
	
	def ratio= new_ratio
	  raise ArgumentError, "ratio #{new_ratio} is not a Float" if !new_ratio.is_a?(Float)
	  raise RangeError, "ratio #{new_ratio} is less than or equal to 0.0" if new_ratio <= 0.0
		  
	  x = Math.log2 new_ratio
		
	  total_cent = (x * @cents_per_octave).round
	end

	def <=> (other)
	  total_cent <=> other.total_cent
	end
	
	def + (other)
	  self.class.new :octave => (@octave + other.octave), :semitone => (@semitone + other.semitone), :cent => (@cent + other.cent)
	end

	def - (other)
	  self.class.new :octave => (@octave - other.octave), :semitone => (@semitone - other.semitone), :cent => (@cent - other.cent)
	end
	
	private
		
	def normalize
	  centTotal = (octave * @cents_per_octave) + (semitone * CENTS_PER_SEMITONE) + cent
	  
	  @octave = centTotal / @cents_per_octave
	  centTotal -= @octave * @cents_per_octave
	  
	  @semitone = centTotal / CENTS_PER_SEMITONE
	  centTotal -= @semitone * CENTS_PER_SEMITONE
	  
	  @cent = centTotal
	  return true
	end
  end
end