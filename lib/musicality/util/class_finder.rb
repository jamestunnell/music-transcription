module Musicality

# Attempts to locate a class, looking through modules if necessary.
class ClassFinder

  # Look for a class by its name (including scoping modules).
  #
  # @param [String] name The class name (including scoping modules).
  #
  def self.find_by_name name
    tokens = name.scan /\w+/
    
    modul = Kernel
    
    for i in 0...(tokens.count - 1)
      begin
        modul = modul.const_get(tokens[i].to_sym)
      rescue
        return nil
      end
    end
    
    begin
      return modul.const_get tokens.last.to_sym
    rescue
      return nil
    end
  end
end

end

