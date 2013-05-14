require 'facets/equitable'

module Musicality

class EnvelopeFeature
  include Equitable(:type, :count)
  
  RISING = :envelopeSegmentRising
  FALLING = :envelopeSegmentFalling
  HOLDING = :envelopeSegmentHolding
  
  attr_reader :type
  attr_accessor :count
  
  def initialize type, count
    @type = type
    @count = count
  end
  
  def rising?
    return @type == RISING
  end

  def falling?
    return @type == FALLING
  end
  
  def holding?
    return @type == HOLDING
  end
end

def rising count
  EnvelopeFeature.new(EnvelopeFeature::RISING, count)
end

def falling count
  EnvelopeFeature.new(EnvelopeFeature::FALLING, count)
end

def holding count
  EnvelopeFeature.new(EnvelopeFeature::HOLDING, count)
end

# Methods for breaking up an envelope into segments of
# rising, falling, and holding.
class EnvelopeDissection

  # break up an envelope into segments of rising, falling, and holding.
  # @return [Array] of EnvelopeSegment objects.
  def self.identify_features envelope, feature_threshold
    derivative = @envelope.derivative.normalize
    
    segments = []
    
    current_count = 0
    current_type = nil
    derivative.data.each_index do |i|
      if derivative.data[i] > feature_threshold
        type = RISING
      elsif derivative.data[i] < -feature_threshold
        type = FALLING
      else
        type = HOLDING
      end
      
      if type == current_type
        current_count += 1
      else
        unless current_type.nil?
          segments.push(EnvelopeSegment.new(current_type, current_count))
        end
        current_type = type
        current_count = 1
      end
    end
    
    unless current_type.nil?
      segments.push(EnvelopeSegment.new(current_type, current_count))
    end
    
    return segments
  end

  # Tries to eliminate segments with count shorter than given min count
  # by coalesing with neighboring segments.
  def self.coalesce_features features, min_feature_count
    
    coalesced = [ features[0] ]
    
    # look for following coalescing opportunities
    # 1. short holding segment (just tack count onto prev segment)
    # 2. short segment surrounded by two features of the same type (combine all three into one)
    
    i = 1
    while i < features.count do
      feature = features[i]
      
      incr = 1
      if feature.count < min_feature_count
        if feature.holding?
          coalesced.last.count += feature.count
        elsif (i < (features.count - 1) && (coalesced.last.type == features[i+1].type))
          coalesced.last.count += feature.count
          coalesced.last.count += features[i+1].count
          incr = 2
        else
          coalesced.push(feature)
        end
      else
        coalesced.push(feature)
      end
      i += incr
    end
    
    features = coalesced
    coalesced = []
    
    # look for two or more consecutive short features of same type to coalesce
    
    features.each do |feature|
      if coalesced.empty?
        coalesced.push feature
      elsif feature.type == coalesced.last.type
        coalesced.last.count += feature.count
      else
        coalesced.push feature
      end
    end
    
    return coalesced
  end

end
end
