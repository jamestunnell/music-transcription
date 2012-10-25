module Musicality

# Combine functions that are each applicable for a non-overlapping domain.
#
# @author James Tunnell
class PiecewiseFunction
  attr_reader :pieces
  
  def initialize
    @pieces = { }
  end
  
  # Add a function piece, which covers the given domain (includes domain start 
  # but not the end).
  # @param [Range] domain The function domain. If this overlaps an existing domain,
  #                       the existing domain will be split with the non-
  #                       overlapping pieces kept and the overlapping old piece
  #                       discarded.
  def add_piece domain, func
    
    raise ArgumentError, "domain is not a Range" if !domain.is_a? Range
    raise ArgumentError, "func is not a Proc" if !func.is_a? Proc
    
    both_overlaps = @pieces.select { |test_domain, func| test_domain.include?(domain.begin) && test_domain.include?(domain.end) }
    if !both_overlaps.empty?
      raise StandardError, "only one overlap should ever occur" if both_overlaps.count > 1      
      
      orig_domain_a = both_overlaps.keys.first.begin...domain.begin
      orig_domain_b = domain.end...both_overlaps.keys.first.end
      orig_func = both_overlaps.values.first
      
      @pieces.delete both_overlaps.keys.first
      @pieces[orig_domain_a] = orig_func
      @pieces[orig_domain_b] = orig_func
    else
      min_overlaps = @pieces.select { |test_domain, func| test_domain.include?(domain.begin) }

      if !min_overlaps.empty?
        raise StandardError, "only one overlap should ever occur" if min_overlaps.count > 1      
                
        orig_domain = min_overlaps.keys.first.begin...domain.begin
        orig_func = min_overlaps.values.first
          
        @pieces.delete min_overlaps.keys.first
        @pieces[orig_domain] = orig_func
      end      

      max_overlaps = @pieces.select { |test_domain, func| test_domain.include? (domain.end) }
      
      if !max_overlaps.empty?
        raise StandardError, "only one overlap should ever occur" if max_overlaps.count > 1      
        
        orig_domain = domain.end...max_overlaps.keys.first.end
        orig_func = max_overlaps.values.first
        
        @pieces.delete max_overlaps.keys.first
        @pieces[orig_domain] = orig_func
      end
    end
    
    @pieces[domain.begin...domain.end] = func
  end
  
  # Evaluate the piecewise function by finding a function piece whose domain 
  # includes the given independent value.
  def evaluate_at x
    y = nil
    
    @pieces.each do |domain, func|
      if domain.include? x
        y = func.call x
        break
      end
    end
    
    return y
  end
end

end
