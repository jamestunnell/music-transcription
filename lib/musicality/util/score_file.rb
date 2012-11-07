require 'yaml'
module Musicality

# Load/Save a Score YAML file.
# 
# Uses a YAML/hash file format, taking advantage of the hash-makeable idiom used
# in almost all the music composition classes. See the HashMake class for more 
# details on the hash-makeable idiom. By using this idiom, no special ruby 
# classes are referenced in the YAML file output. This guards against future 
# version incompatibility by only using basic types, as long as the hash-args 
# used for initialization are not deprecated.
#
# @author James Tunnell
class ScoreFile

  # Load a Score from a YAML/hash file.
  # @param [String] filename The filename to load from.
  def self.load filename
    hash = nil
    File.open(filename, "r") do |file|
      hash = YAML.load file.read
    end
    raise "Could not load score hash from file #{filename}" if hash.nil?
    
    return Score.make_from_hash hash
  end
  
  # Save a score to a YAML/hash file
  # @param [String] filename The filename to save to.
  def self.save score, filename
    hash = score.save_to_hash
    
    File.open(filename, "w") do |file|
      file.write hash.to_yaml
    end
  end
end

end

